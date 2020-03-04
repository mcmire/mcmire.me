module.exports = {
  presets: ["@babel/preset-env"],
  plugins: [
    "lodash",
    [
      "prismjs",
      {
        // https://prismjs.com/index.html#supported-languages
        languages: ["bash", "css", "html", "js"],
        plugins: [],
        theme: "coy",
        css: true
      }
    ]
  ]
};
