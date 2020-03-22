// Source: less-hsluv plugin
// (https://github.com/klippersubs/less-hsluv/blob/master/lib/hsluv.js)

const _ = require("lodash");
const path = require("path");
const { execFileSync } = require("child_process");
const sass = require("sass");
const hsluv = require("hsluv");

const COLORS = readColorsMap();

//console.log("COLORS", COLORS);

function readColorsMap() {
  const output = execFileSync(path.resolve(__dirname, "map.js"));

  return _.reduce(
    JSON.parse(output),
    (obj, value, name) => {
      return { ...obj, [_.kebabCase(name)]: value };
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

const limitPercentage = createLimiter(0, 100);
const limitAlpha = createLimiter(0, 1);

module.exports = {
  hsluv(hArg, sArg, lArg) {
    validateArgumentType("$h", hArg, sass.types.Number);
    validateUnitlessNumber("$h", hArg);

    validateArgumentType("$s", sArg, sass.types.Number);
    validateNumberWithUnit("$s", sArg, "%");

    validateArgumentType("$l", lArg, sass.types.Number);
    validateNumberWithUnit("$l", lArg, "%");

    const h = hArg.getValue();
    const s = limitPercentage(sArg.getValue());
    const l = limitPercentage(lArg.getValue());

    const values = hsluv
      .hsluvToRgb([h, s, l])
      .map(n => Math.floor(n * 255 + 0.5));

    return new sass.types.Color(...values);
  },

  hsluva(hArg, sArg, lArg, aArg) {
    validateArgumentType("$h", hArg, sass.types.Number);
    validateUnitlessNumber("$h", hArg);

    validateArgumentType("$s", sArg, sass.types.Number);
    validateNumberWithUnit("$s", sArg, "%");

    validateArgumentType("$l", lArg, sass.types.Number);
    validateNumberWithUnit("$l", lArg, "%");

    console.log("aArg", aArg);

    if (aArg != null) {
      validateArgumentType("$a", aArg, sass.types.Number);
      validateUnitlessNumber("$a", aArg);
    }

    const h = hArg.getValue();
    const s = limitPercentage(sArg.getValue());
    const l = limitPercentage(lArg.getValue());
    const a = aArg == null ? 1 : limitAlpha(aArg.getValue());

    const values = [
      ...hsluv.hsluvToRgb([h, s, l]).map(n => Math.floor(n * 255 + 0.5)),
      a
    ];

    return new sass.types.Color(...values);
  },

  color(nameArg) {
    validateArgumentType("$name", nameArg, sass.types.String);

    const name = nameArg.getValue();

    if (name in COLORS) {
      return new sass.types.Color(...COLORS[name].rgbValues);
    } else {
      throw new Error(`${name} is not a defined color!`);
    }
  },

  getColors() {
    const map = new sass.types.Map(Object.keys(COLORS).length);

    _.each(Object.keys(COLORS), (name, index) => {
      const color = COLORS[name];
      map.setKey(index, new sass.types.String(name));
      map.setValue(index, new sass.types.Color(...color.rgbValues));
    });

    return map;
  }
};
