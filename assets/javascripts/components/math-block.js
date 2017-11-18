import katex from "katex";

export default class MathBlock {
  constructor({ element }) {
    this.element = element;
  }

  render() {
    const newWrapper = document.createElement("div");
    newWrapper.classList.add("math");
    katex.render(this.element.textContent, newWrapper);
    this.element.parentNode.insertBefore(newWrapper, this.element);
    this.element.parentNode.removeChild(this.element);
  }
}
