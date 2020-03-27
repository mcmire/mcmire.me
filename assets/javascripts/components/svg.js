import { throttle } from "lodash";

const THROTTLE_TIMEOUT = 150;
const MOBILE_LARGE = 425;

export default class Svg {
  constructor(element) {
    this.element = element;
    this.width = this.element.dataset.width;
    this.height = this.element.dataset.height;
    this.render = throttle(this.render.bind(this), THROTTLE_TIMEOUT);
  }

  activate() {
    window.addEventListener("resize", this.render);
  }

  render() {
    if (screen.width >= MOBILE_LARGE) {
      if (this.width != null) {
        this.element.setAttribute("width", `${this.width}px`);
      }

      if (this.height != null) {
        this.element.setAttribute("height", `${this.height}px`);
      }
    } else {
      this.element.removeAttribute("width");
      this.element.removeAttribute("height");
    }
  }
}
