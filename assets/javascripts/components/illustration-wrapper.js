export default class IllustrationWrapper {
  constructor({ element, illustrationConstructor }) {
    this.element = element;
    this.illustrationConstructor = illustrationConstructor;
    this.width = parseInt(this.element.dataset.width, 10);
    this.height = parseInt(this.element.dataset.height, 10);
    const svgElement = this.element.querySelector("svg");
    this.illustration = new illustrationConstructor({ element: svgElement });
    this.overlayMade = false;
    this.isPlaying = false;
    this.hasBeenPlayed = false;
  }

  activate() {
    this.element.addEventListener("click", event => {
      event.preventDefault();
      if (!this.isPlaying) {
        this.isPlaying = true;
        this.render();
        this.illustration.play().then(() => {
          this.isPlaying = false;
          this.hasBeenPlayed = true;
          this.render();
        });
      }
    });
  }

  render() {
    if (this.width > 0) {
      this.element.style.width = `${this.width}px`;
    }

    if (this.height > 0) {
      this.element.style.height = `${this.height}px`;
    }

    if (!this.overlayMade) {
      const { overlay, playButton, replayButton } = this.makeOverlay();
      this.overlay = overlay;
      this.playButton = playButton;
      this.replayButton = replayButton;
      this.element.appendChild(this.overlay);
      this.overlayMade = true;
    }

    if (this.isPlaying) {
      this.element.classList.add("is-playing");
      this.overlay.classList.add("invisible");
    } else {
      this.element.classList.remove("is-playing");
      this.overlay.classList.remove("invisible");
    }

    if (this.hasBeenPlayed) {
      this.playButton.classList.add("hidden");
      this.replayButton.classList.remove("hidden");
    } else {
      this.playButton.classList.remove("hidden");
      this.replayButton.classList.add("hidden");
    }
  }

  makeOverlay() {
    const overlay = document.createElement("div");
    overlay.classList.add("overlay");
    overlay.classList.add("invisible");

    const playButton = document.createElement("button");
    playButton.classList.add("play");
    playButton.classList.add("hidden");
    overlay.appendChild(playButton);

    const replayButton = document.createElement("button");
    replayButton.classList.add("replay");
    replayButton.classList.add("hidden");
    overlay.appendChild(replayButton);

    return { overlay, playButton, replayButton };
  }
}
