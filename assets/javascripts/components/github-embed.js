import Prism from "../vendor/prism";
import CodeBlock from "./code-block";

export default class GithubEmbed {
  constructor({ codeModal, element }) {
    this.codeModal = codeModal;
    this.element = element;

    this.url = element.dataset.url;
    this.language = element.dataset.language;
  }

  render() {
    fetch(this.url).then(response => {
      response.text().then(content => {
        const [pre, code] = this._buildPre(content);
        this.element.parentNode.replaceChild(pre, this.element);
        const codeBlock = new CodeBlock({
          codeModal: this.codeModal,
          element: pre
        });
        Prism.highlightElement(code);
        codeBlock.render();
      });
    });
  }

  _buildPre(content) {
    const pre = document.createElement("pre");
    const code = document.createElement("code");
    code.classList.add(`language-${this.language}`);
    code.textContent = content;
    pre.appendChild(code);
    return [pre, code];
  }
}
