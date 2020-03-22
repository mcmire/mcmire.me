const hsluv = require("hsluv");
const Color = require("color");
const sass = require("sass");

const HSLUV_REGEXP = /^hsluv\((\d+(?:\.\d+)?)+, (\d+(?:\.\d+)?%?), (\d+(?:\.\d+)?%?)\)$/;

class HsluvColor {
  constructor(h, s, l) {
    this.h = h;
    this.s = s;
    this.l = l;
  }

  cloneWith(changes) {
    const h = changes.h == null ? this.h : changes.h;
    const s = changes.s == null ? this.h : changes.s;
    const l = changes.l == null ? this.h : changes.l;
    return new HsluvColor(h, s, l);
  }

  transform(name, value) {
    const color = this.toColor();

    if (name === "tint") {
      const newColor = color.mix(Color.rgb(0, 0, 0), value);
      return HsluvColor.fromColor(newColor);
    } else if (typeof color[name] === "function") {
      return HsluvColor.fromColor(color[name](value));
    } else {
      throw new Error(`${name} isn't a method on Color!`);
    }
  }

  toColor() {
    const rgb = hsluv
      .hsluvToRgb([this.h, this.s, this.l])
      .map(value => Math.round(value * 255));
    //console.log("toColor", "h", this.h, "s", this.s, "l", this.l, "rgb", rgb);
    return Color.rgb(rgb);
  }

  toSassColor() {
    const rgb = hsluv
      .hsluvToRgb([this.h, this.s, this.l])
      .map(value => Math.round(value * 255));
    //console.log(
    //"toSassColor",
    //"h",
    //this.h,
    //"s",
    //this.s,
    //"l",
    //this.l,
    //"rgb",
    //rgb
    //);
    return new sass.types.Color(...rgb);
  }

  toRgbValues() {
    return this.toColor()
      .rgb()
      .array();
  }

  toHex() {
    return this.toColor().hex();
  }
}
module.exports = HsluvColor;

HsluvColor.create = value => {
  if (Array.isArray(value)) {
    return HsluvColor.fromColor(Color.rgb(value));
  } else if (value instanceof Color) {
    return HsluvColor.fromColor(value);
  } else if (value instanceof sass.types.Color) {
    return HsluvColor.fromSassColor(value);
  } else if (typeof value === "string") {
    return HsluvColor.fromHsluvString(value);
  } else {
    throw new Error(`Couldn't convert to HsluvColor: ${JSON.stringify(value)}`);
  }
};

HsluvColor.fromSassColor = sassColor => {
  const rgb = [sassColor.getR(), sassColor.getG(), sassColor.getB()].map(
    value => value / 255
  );
  return new HsluvColor(...hsluv.rgbToHsluv(rgb));
};

HsluvColor.fromColor = color => {
  const rgb = color
    .rgb()
    .array()
    .map(value => value / 255);
  return new HsluvColor(...hsluv.rgbToHsluv(rgb));
};

HsluvColor.fromHsluvString = value => {
  const match = HSLUV_REGEXP.exec(value);

  if (match) {
    const [rawH, rawS, rawL] = match.slice(1);
    const h = parseInt(rawH, 10);
    const s = /%$/.test(rawS)
      ? parseFloat(rawS.slice(0, -1), 10)
      : parseFloat(rawS, 10) * 100;
    const l = /%$/.test(rawL)
      ? parseFloat(rawL.slice(0, -1), 10)
      : parseFloat(rawL, 10) * 100;
    //console.log("fromHsluvString", "h", h, "s", s, "l", l);
    return new HsluvColor(h, s, l);
  } else {
    throw new Error(`Couldn't parse as an hsluv string: ${value}`);
  }
};
