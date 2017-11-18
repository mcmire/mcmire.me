export default class Spoiler {
  constructor({ element }) {
    this.element = element;
    this._toggle = this._toggle.bind(this);
  }

  activate() {
    this.element.addEventListener("click", this._toggle);
  }

  _toggle() {
    this.element.classList.toggle("revealed");
  }
}
