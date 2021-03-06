import { map, invokeMap } from "lodash";

import CodeBlock from "./components/code-block";
import CodeModal from "./components/code-modal";
import GithubEmbed from "./components/github-embed";
import Grid from "./components/grid";
import IllustrationWrapper from "./components/illustration-wrapper";
import MathBlock from "./components/math-block";
import Spoiler from "./components/spoiler";
import Svg from "./components/svg";

import illustrationRegistry from "./services/illustration-registry";

function renderGrid() {
  const grid = new Grid({
    windowElement: window,
    bodyElement: document.body,
    contentElement: document.querySelector("[data-role='content']")
  });
  grid.activate();
  grid.render();
}

function buildActivatedCodeModal() {
  const modalOverlay = document.querySelector("[data-role='modal-overlay']");
  const modalWindow = document.querySelector("[data-role='modal-window']");

  if (modalOverlay && modalWindow) {
    const codeModal = new CodeModal({
      bodyElement: document.body,
      modalOverlay: modalOverlay,
      modalWindow: modalWindow
    });
    codeModal.activate();
    return codeModal;
  }
}

function renderCodeBlocks(codeModal) {
  const elements = document.querySelectorAll("pre");
  const codeBlocks = map(elements, element => {
    return new CodeBlock({ codeModal, element });
  });
  invokeMap(codeBlocks, "activate");
  invokeMap(codeBlocks, "render");
}

function renderGithubEmbeds(codeModal) {
  const elements = document.querySelectorAll("[data-role='github-embed']");
  const codeBlocks = map(elements, element => {
    return new GithubEmbed({ codeModal, element });
  });
  invokeMap(codeBlocks, "render");
}

function renderMathBlocks() {
  const elements = document.querySelectorAll("script[type='math/katex']");

  elements.forEach(element => {
    const mathBlock = new MathBlock({ element });
    mathBlock.render();
  });
}

function initSpoilers() {
  const elements = document.querySelectorAll(".spoiler");

  elements.forEach(element => {
    const spoiler = new Spoiler({ element });
    spoiler.activate();
  });
}

function initIllustrations() {
  document.querySelectorAll("[data-illustration]").forEach(element => {
    const illustrationName = element.getAttribute("data-illustration");
    const illustrationConstructor = illustrationRegistry.find(illustrationName);
    if (illustrationConstructor) {
      const illustrationWrapper = new IllustrationWrapper({
        element,
        illustrationConstructor
      });
      illustrationWrapper.activate();
      illustrationWrapper.render();
    }
  });
}

function initSvg() {
  document.querySelectorAll("svg").forEach(element => {
    const svg = new Svg(element);
    svg.activate();
    svg.render();
  });
}

export default function init() {
  renderGrid();

  const codeModal = buildActivatedCodeModal();

  if (codeModal) {
    renderCodeBlocks(codeModal);
    renderGithubEmbeds(codeModal);
  }

  renderMathBlocks();
  initSpoilers();
  initIllustrations();
  initSvg();
}
