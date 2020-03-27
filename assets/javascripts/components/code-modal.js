import { invoke } from "lodash";
import "scopedQuerySelectorShim/dist/scopedQuerySelectorShim";

import transitionEndEventName from "../services/transition-end-event-name";

function copyCodeBlock(codeBlock) {
  const copyOfCodeBlock = codeBlock.cloneNode(true);
  const everythingExceptCode = copyOfCodeBlock.querySelectorAll(
    ":scope > :not(code)"
  );
  invoke(everythingExceptCode, "remove");
  return copyOfCodeBlock;
}

export default class CodeModal {
  constructor({ bodyElement, modalOverlay, modalWindow }) {
    this.bodyElement = bodyElement;
    this.modalOverlay = modalOverlay;
    this.modalWindow = modalWindow;
    this.modalControls = this.modalWindow.querySelector(
      "[data-role='modal-controls']"
    );
    this.closeButton = this.modalControls.querySelector(
      "[data-role='modal-close']"
    );
    this.contentElement = this.modalWindow.querySelector(
      "[data-role='modal-content']"
    );

    this.close = this.close.bind(this);
    this._stopPropagation = this._stopPropagation.bind(this);
    this._clear = this._clear.bind(this);
    this._copyContent = this._copyContent.bind(this);
    this._resetCopyButton = this._resetCopyButton.bind(this);
  }

  activate() {
    this.closeButton.addEventListener("click", this.close);
  }

  open(codeBlock) {
    if (this.clearTimer != null) {
      clearTimeout(this.clearTimer);
      this.clearTimer = null;
    }
    if (this.resetCopyButtonTimer != null) {
      clearTimeout(this.resetCopyButtonTimer);
      this.resetCopyButtonTimer = null;
    }

    this.copyButton = this._createCopyButton();
    this.copyButton.addEventListener("click", this._copyContent);
    this.modalControls.appendChild(this.copyButton);

    const copyOfCodeBlock = copyCodeBlock(codeBlock);
    copyOfCodeBlock.classList.add("expanded");

    this.bodyElement.classList.add("code-modal-open");

    this.modalOverlay.classList.remove("closed");
    this.modalOverlay.classList.add("open");

    this.modalWindow.classList.remove("closed");
    this.modalWindow.classList.add("open");

    this.contentElement.innerHTML = "";
    this.contentElement.appendChild(copyOfCodeBlock);
    this.contentElement.addEventListener("click", this._stopPropagation);
  }

  close(event) {
    event.preventDefault();

    this.bodyElement.classList.remove("code-modal-open");

    this.modalOverlay.classList.remove("open");
    this.modalOverlay.classList.add("closed");

    this.modalWindow.classList.remove("open");
    this.modalWindow.classList.add("closed");
    this.clearTimer = setTimeout(this._clear, 300);
  }

  _createCopyButton() {
    const element = document.createElement("button");
    element.classList.add("modal-copy-button");
    element.innerText = "Copy";
    return element;
  }

  _clear() {
    this.modalWindow.removeEventListener(transitionEndEventName, this._clear);
    this.contentElement.innerHTML = "";
    this.modalControls.removeChild(this.copyButton);
    this.copyButton = null;
  }

  _stopPropagation(event) {
    event.stopPropagation();
  }

  _copyContent(event) {
    event.preventDefault();
    navigator.clipboard.writeText(this.contentElement.innerText);
    this.copyButton.classList.add("copied");
    this.copyButton.innerHTML = "Copied! &nbsp;✔︎";

    this.resetCopyButtonTimer = setTimeout(this._resetCopyButton, 3000);
  }

  _resetCopyButton() {
    this.copyButton.classList.remove("copied");
    this.copyButton.innerText = "Copy";
  }
}
