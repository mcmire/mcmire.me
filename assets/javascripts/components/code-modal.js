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
    this.closeButton = this.modalWindow.querySelector(
      "[data-role='modal-close']"
    );
    this.contentElement = this.modalWindow.querySelector(
      "[data-role='modal-content']"
    );

    this.close = this.close.bind(this);
    this._stopPropagation = this._stopPropagation.bind(this);
    this._clear = this._clear.bind(this);
  }

  activate() {
    this.closeButton.addEventListener("click", this.close);
  }

  open(codeBlock) {
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
    this.modalWindow.addEventListener(transitionEndEventName, this._clear);
  }

  _clear() {
    this.modalWindow.removeEventListener(transitionEndEventName, this._clear);
    this.contentElement.innerHTML = "";
  }

  _stopPropagation(event) {
    event.stopPropagation();
  }
}
