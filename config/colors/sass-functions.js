// Source: less-hsluv plugin
// (https://github.com/klippersubs/less-hsluv/blob/master/lib/hsluv.js)

const _ = require("lodash");
const path = require("path");
const { execFileSync } = require("child_process");
const sass = require("sass");
const hsluv = require("hsluv");

const HsluvColor = require("./HsluvColor");

const COLORS = readColorsMap();

function readColorsMap() {
  const output = execFileSync(path.resolve(__dirname, "map.js"));

  return _.reduce(
    JSON.parse(output),
    (obj, colorValues, name) => {
      return { ...obj, [_.kebabCase(name)]: HsluvColor.create(colorValues) };
    },
    {}
  );
}

function createLimiter(min, max) {
  return value => Math.max(min, Math.min(value, max));
}

function validateArgumentType(name, arg, type) {
  if (!(arg instanceof type)) {
    throw new Error(`${name}: Expected a number.`);
  }
}

function validateUnitlessNumber(name, arg) {
  if (arg.getUnit() !== "") {
    throw new Error(`${name}: Expected a unitless number.`);
  }
}

function validateNumberWithUnit(name, arg) {
  if (arg.getUnit() !== "%") {
    throw new Error(`${name}: Expected a unit of %.`);
  }
}

function wrapAngle(angle) {
  const wrappedAngle = angle % 360;
  return wrappedAngle >= wrappedAngle ? wrappedAngle : 360 - wrappedAngle;
}

const limitPercentage = createLimiter(0, 100);
//const limitAlpha = createLimiter(0, 1);

const sassFunctions = {
  hsluv(hueArg, saturationArg, lightnessArg) {
    validateArgumentType("$hue", hueArg, sass.types.Number);
    validateUnitlessNumber("$hue", hueArg);

    validateArgumentType("$saturation", saturationArg, sass.types.Number);
    validateNumberWithUnit("$saturation", saturationArg, "%");

    validateArgumentType("$lightness", lightnessArg, sass.types.Number);
    validateNumberWithUnit("$lightness", lightnessArg, "%");

    const h = wrapAngle(hueArg.getValue());
    const s = limitPercentage(saturationArg.getValue());
    const l = limitPercentage(lightnessArg.getValue());

    return new HsluvColor(h, s, l).toSassColor();
  },

  /*
  hsluva(hueArg, saturationArg, lightnessArg, aArg) {
    validateArgumentType("$hue", hueArg, sass.types.Number);
    validateUnitlessNumber("$hue", hueArg);

    validateArgumentType("$saturation", saturationArg, sass.types.Number);
    validateNumberWithUnit("$saturation", saturationArg, "%");

    validateArgumentType("$lightness", lightnessArg, sass.types.Number);
    validateNumberWithUnit("$lightness", lightnessArg, "%");

    console.log("aArg", aArg);

    if (aArg != null) {
      validateArgumentType("$a", aArg, sass.types.Number);
      validateUnitlessNumber("$a", aArg);
    }

    const h = hueArg.getValue();
    const s = limitPercentage(saturationArg.getValue());
    const l = limitPercentage(lightnessArg.getValue());
    const a = aArg == null ? 1 : limitAlpha(aArg.getValue());

    const values = [
      ...hsluv.hsluvToRgb([h, s, l]).map(n => Math.floor(n * 255 + 0.5)),
      a
    ];

    return new sass.types.Color(...values);
  },
  */

  color(nameArg) {
    validateArgumentType("$name", nameArg, sass.types.String);

    const name = nameArg.getValue();

    if (name in COLORS) {
      /*
      if (name === "code-almost-white") {
        console.log(
          "color",
          COLORS[name],
          "sassColor",
          COLORS[name].toSassColor()
        );
      }
      */
      return COLORS[name].toSassColor();
    } else {
      throw new Error(`${name} is not a defined color!`);
    }
  },

  getColors() {
    const map = new sass.types.Map(Object.keys(COLORS).length);

    _.each(Object.keys(COLORS), (name, index) => {
      const color = COLORS[name];
      map.setKey(index, new sass.types.String(name));
      map.setValue(index, color.toSassColor());
    });

    return map;
  },

  adjustHsluvColor(colorArg, hueArg, saturationArg, lightnessArg) {
    validateArgumentType("$color", colorArg, sass.types.Color);

    validateArgumentType("$hue", hueArg, sass.types.Number);
    validateUnitlessNumber("$hue", hueArg);
    const hue = hueArg.getValue();

    validateArgumentType("$saturation", saturationArg, sass.types.Number);
    const saturation =
      saturationArg.getUnit() === "%"
        ? saturationArg.getValue()
        : saturationArg.getValue() * 100;

    validateArgumentType("$lightness", lightnessArg, sass.types.Number);
    const lightness =
      lightnessArg.getUnit() === "%"
        ? lightnessArg.getValue()
        : lightnessArg.getValue() * 100;

    const hsluvColor = HsluvColor.create(colorArg);
    const changedHsluvColor = hsluvColor.cloneWith({
      h: hsluvColor.h + hue,
      s: hsluvColor.s + saturation,
      l: hsluvColor.l + lightness
    });
    /*
    console.log(
      "adjustHsluvColor",
      "colorArg",
      colorArg,
      "hsluvColor",
      hsluvColor,
      "changedHsluvColor",
      changedHsluvColor,
      "hue",
      hue,
      "saturation",
      saturation,
      "lightness",
      lightness
    );
    */
    return changedHsluvColor.toSassColor();
  }
};

module.exports = {
  "hsluv($hue, $saturation, $lightness)": sassFunctions.hsluv,
  //"hsluva($hue, $saturation, $lightness, $alpha)": sassFunctions.hsluva,
  "color($name)": sassFunctions.color,
  "get-colors()": sassFunctions.getColors,
  "adjust-hsluv-color($color, $hue: 0, $saturation: 0, $lightness: 0)":
    sassFunctions.adjustHsluvColor
};
