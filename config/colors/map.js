#!/usr/bin/env node

const _ = require("lodash");
const HsluvColor = require("./HsluvColor");

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
  codeBlue: "hsluv(257.5, 85%, 49.5%)",
  codeGreen: "hsluv(117.5, 98.5%, 57.5%)",
  codePurple: "hsluv(284, 71.5%, 54.5%)",
  codeLightGray: "hsluv(209, 8%, 77%)",
  codeLightGreen: "hsluv(118.5, 65%, 96%)",
  codeLightRed: "hsluv(12, 58%, 91.5%)",
  codeMediumGray: "hsluv(238, 21.5%, 57%)",
  codeAlmostWhite: "hsluv(266, 31.5%, 98.5%)",
  yellow: "hsluv(86, 90%, 95%)",
  yellowishGray: "hsluv(86, 22%, 53%)"
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

const generatedColors = _.reduce(
  COLORS,
  (obj, value, name) => {
    const hsluvColor = _.isPlainObject(value)
      ? value.transformations.reduce((hsluvColor, transformation) => {
          return hsluvColor.transform(transformation.fn, transformation.by);
        }, HsluvColor.create(value.from))
      : HsluvColor.create(value);

    return { ...obj, [name]: hsluvColor.toRgbValues() };
  },
  {}
);

console.log(JSON.stringify(generatedColors));
