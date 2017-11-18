// http://beej.us/blog/2010/02/html5s-canvas-part-ii-pixel-manipulation/
function setPixel({ imageData, position: { x, y }, color: { r, g, b, a } }) {
  const index = (x + y * imageData.width) * 4;
  imageData.data[index + 0] = r;
  imageData.data[index + 1] = g;
  imageData.data[index + 2] = b;
  imageData.data[index + 3] = a;
}

function pctToHex(pct) {
  return pct * 256 - 1;
}

function removeUnit(numberWithUnit) {
  if (numberWithUnit == "" || numberWithUnit == null) {
    return 0;
  } else {
    return numberWithUnit.toString().replace(/\w+$/, "");
  }
}

function addPx(number) {
  return number + "px";
}

const G_KEY = 71;
const K_KEY = 74;
const J_KEY = 75;
const SHIFT_OFFSETS = { [K_KEY]: -1, [J_KEY]: -1 };

export default class Grid {
  constructor({ windowElement, bodyElement, contentElement }) {
    this._windowElement = windowElement;
    this._bodyElement = bodyElement;
    this._contentElement = contentElement;
    this._load();

    this._respondToKeyDown = this._respondToKeyDown.bind(this);
  }

  activate() {
    this._windowElement.addEventListener("keydown", this._respondToKeyDown);
  }

  render() {
    const contentStyle = this._contentElement.style;

    if (this._isVisible) {
      if (this._gridDataUrl == null) {
        this._gridDataUrl = this._generate();
      }
      contentStyle.backgroundImage = "url(" + this._gridDataUrl + ")";
      contentStyle.backgroundPositionX = addPx(this._backgroundPosition.x);
      contentStyle.backgroundPositionY = addPx(this._backgroundPosition.y);
    } else {
      contentStyle.backgroundImage = "none";
    }
  }

  _respondToKeyDown(event) {
    if (event.shiftKey) {
      if (event.keyCode == G_KEY) {
        this._toggle();
        this.render();
      } else if (event.keyCode == K_KEY || event.keyCode == J_KEY) {
        this._shift(event);
        this.render();
      }
    }
  }

  _generate() {
    const width = 1;
    const bodyStyle = window.getComputedStyle(this._bodyElement);
    const height = removeUnit(bodyStyle.lineHeight);

    const canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;
    const ctx = canvas.getContext("2d");
    const imageData = ctx.createImageData(width, height);

    setPixel({
      imageData: imageData,
      position: { x: 0, y: height - 1 },
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.2) }
    });
    setPixel({
      imageData: imageData,
      position: { x: 0, y: height * 0.25 - 1 },
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.05) }
    });
    setPixel({
      imageData: imageData,
      position: { x: 0, y: height * 0.5 - 1 },
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.1) }
    });
    setPixel({
      imageData: imageData,
      position: { x: 0, y: height * 0.75 - 1 },
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.05) }
    });
    ctx.putImageData(imageData, 0, 0);

    canvas.toDataURL("image/png");
  }

  _shift(event) {
    this._backgroundPosition.y += SHIFT_OFFSETS[event.keyCode];
    this._save();
  }

  _toggle() {
    if (this._isVisible) {
      this._hide();
    } else {
      this._show();
    }
  }

  _show() {
    this._isVisible = true;
    this._save();
  }

  _hide() {
    this._isVisible = false;
    this._save();
  }

  _load() {
    const rawData = localStorage.getItem("lic-grid");

    if (rawData) {
      const data = JSON.parse(rawData);
      this._isVisible = data.isVisible;
      this._backgroundPosition = data.backgroundPosition;
    } else {
      this._isVisible = false;
      this._backgroundPosition = {
        x: removeUnit(this._contentElement.style.backgroundPositionX),
        y: removeUnit(this._contentElement.style.backgroundPositionY)
      };
      this._save();
    }
  }

  _save() {
    const data = JSON.stringify({
      isVisible: this._isVisible,
      backgroundPosition: this._backgroundPosition
    });
    localStorage.setItem("lic-grid", data);
  }
}
