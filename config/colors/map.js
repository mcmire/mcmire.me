#!/usr/bin/env node

const COLORS = {
  blue: "hsluv(255, 82%, 46.5%)",
  lightBlueishGray: "hsluv(244, 16%, 57%)",
  mediumBlueishGray: "hsluv(237, 26%, 38%)",
  lightBlue: "hsluv(243, 67.6%, 95.5%)",
  lightestGray: "hsluv(171.5, 0%, 96.5%)",
  lightGray: "hsluv(172.5, 0%, 92.5%)",
  mediumLightGray: "hsluv(171.5, 0%, 88%)",
  mediumGray: "hsluv(171.5, 0%, 63%)",
  darkGray: "hsluv(171.5, 0%, 21%)",
  lightYellow: "hsluv(71.5, 58.5%, 98.0%)",
  lightRed: "hsluv(359.5, 93%, 95%)",
  reddishGray: "hsluv(12, 6%, 63%)",
  red: "hsluv(12, 67%, 53.5%)",
  white: "hsluv(0, 0%, 100%)",
  black: "hsluv(0, 0%, 0%)",
};

COLORS.lighterBlue = {
  from: COLORS.blue,
  transformations: [{ fn: "tint", by: 0.2 }]
};

COLORS.lightReddishGray = {
  from: COLORS.red,
  transformations: [
    { fn: "lighten", by: 0.2 },
    { fn: "desaturate", by: 0.2 }
  ]
};

//---

const _ = require("lodash");
const hsluv = require("hsluv");
const Color = require("color");

const HSLUV_REGEXP = /^hsluv\((\d+(?:\.\d+)?)+, (\d+(?:\.\d+)?%?), (\d+(?:\.\d+)?%?)\)$/;

class HsluvColor {
  constructor(h, s, l) {
    this.h = h;
    this.s = s;
    this.l = l;
  }

  transform(name, value) {
    const color = this.toColor();

    //console.log("transform", "color", color, "value", value, "name", name)

    if (name === "tint") {
      const newColor = color.mix(new Color(0, 0, 0), value);
      //console.log("TINT", "this", this, "color", color, "newColor", newColor)
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
      .map(value => value * 255);
    return new Color(rgb);
  }

  toRgbValues() {
    const rgb = this.toColor()
      .rgb()
      .array();
    //console.log("HsluvColor", this, "rgb", rgb);
    return rgb;
  }

  toHex() {
    return this.toColor().hex();
  }
}

HsluvColor.fromColor = color => {
  const rgb = color
    .rgb()
    .array()
    .map(value => value / 255);
  return new HsluvColor(...hsluv.rgbToHsluv(rgb));
};

HsluvColor.create = value => {
  if (value instanceof Color) {
    return new HsluvColor.fromColor(value);
  } else {
    return HsluvColor.fromHsluvString(value);
  }
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
    //console.log("value", value, "h", h, "s", s, "l", l)
    return new HsluvColor(h, s, l);
  } else {
    throw new Error(`Couldn't parse as an hsluv string: ${value}`);
  }
};

const generatedColors = _.reduce(
  COLORS,
  (obj, value, name) => {
    const hsluvColor = _.isPlainObject(value)
      ? value.transformations.reduce((hsluvColor, transformation) => {
          return hsluvColor.transform(transformation.fn, transformation.by);
        }, HsluvColor.create(value.from))
      : HsluvColor.create(value);

    return {
      ...obj,
      [name]: { rgbValues: hsluvColor.toRgbValues() }
    };
  },
  {}
);

console.log(JSON.stringify(generatedColors));
