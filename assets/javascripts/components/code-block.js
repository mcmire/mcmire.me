export default class CodeBlock {
  constructor({ codeModal, element }) {
    this.codeModal = codeModal;
    this.element = element;
    this.horizontalOverflowIndicatorElement = this._createHorizontalOverflowIndicatorElement();
    this.verticalOverflowIndicatorElement = this._createVerticalOverflowIndicatorElement();
    this.overlayElement = this._createOverlayElement();
    this.viewInFullButtonElement = this._createViewInFullButtonElement();

    this._expand = this._expand.bind(this);
  }

  render() {
    if (this._doesOverflow()) {
      this.element.classList.add("overflows");
      this.element.appendChild(this.overlayElement);
      this.element.appendChild(this.viewInFullButtonElement);
      this.overlayElement.addEventListener("click", this._expand);
      this.viewInFullButtonElement.addEventListener("click", this._expand);

      if (this._doesOverflowHorizontally()) {
        this.element.appendChild(this.horizontalOverflowIndicatorElement);
      }

      if (this._doesOverflowVertically()) {
        this.element.appendChild(this.verticalOverflowIndicatorElement);
      }
    }
  }

  _expand() {
    this.codeModal.open(this.element);
  }

  _collapse() {
    this.codeModal.close();
  }

  _createHorizontalOverflowIndicatorElement() {
    const element = document.createElement("div");
    element.classList.add("horizontal-overflow-indicator");
    return element;
  }

  _createVerticalOverflowIndicatorElement() {
    const element = document.createElement("div");
    element.classList.add("vertical-overflow-indicator");
    return element;
  }

  _createOverlayElement() {
    const element = document.createElement("div");
    element.classList.add("overlay");
    return element;
  }

  _createViewInFullButtonElement() {
    const element = document.createElement("div");
    element.classList.add("view-in-full");
    element.innerHTML = "View in full";
    return element;
  }

  _doesOverflow() {
    return (
      !this.element.dataset.noOverflow &&
      (this._doesOverflowHorizontally() || this._doesOverflowVertically())
    );
  }

  _doesOverflowHorizontally() {
    return this.element.scrollWidth > this.element.clientWidth;
  }

  _doesOverflowVertically() {
    return this.element.scrollHeight > this.element.clientHeight;
  }
}
