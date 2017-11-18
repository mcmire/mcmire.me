export default class Header {
  constructor({ element, animation }) {
    this.element = element;
    this.animation = animation;
  }

  activate() {
    this.element.addEventListener("mouseover", () => {
      this.animation.play();
    });

    this.element.addEventListener("mouseout", () => {
      this.animation.pause();
    });
  }
}
