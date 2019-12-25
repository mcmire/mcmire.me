// Stolen from:
// <https://github.com/grassdog/middleman-webpack>

const path = require("path");
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const Clean = require("clean-webpack-plugin");
const bourbon = require("bourbon");

const TMP_PATH = ".tmp";
const PUBLIC_PATH = "assets";
const JAVASCRIPTS_PATH = "javascripts";
const STYLESHEETS_PATH = "stylesheets";
const FONTS_PATH = "fonts";

const TMP_DIR = path.resolve(__dirname, TMP_PATH);
const CONTEXT_DIR = path.resolve(__dirname, "assets");
const JAVASCRIPTS_DIR = path.resolve(CONTEXT_DIR, JAVASCRIPTS_PATH);
const STYLESHEETS_DIR = path.resolve(CONTEXT_DIR, STYLESHEETS_PATH);

function shouldOutputSourceMap() {
  return process.env.NODE_ENV === "development";
}

function determineDevtool() {
  if (process.env.NODE_ENV === "development") {
    // The external source map options, such as this one, works in Firefox --
    // the inline source map options don't work
    return "cheap-module-source-map";
  } else {
    return false;
  }
}

function determinePlugins() {
  const plugins = [
    // Always expose NODE_ENV to webpack, in order to use `process.env.NODE_ENV`
    // inside your code for any environment checks; UglifyJS will automatically
    // drop any unreachable code.
    new webpack.DefinePlugin({
      "process.env": {
        NODE_ENV: JSON.stringify(process.env.NODE_ENV)
      }
    }),
    new Clean([TMP_PATH]),
    new ExtractTextPlugin(
      path.join(PUBLIC_PATH, STYLESHEETS_PATH, "[name].bundle.css")
    )
  ];

  if (process.env.NODE_ENV === "production") {
    plugins.push(
      new UglifyJsPlugin({
        sourceMap: shouldOutputSourceMap(),
        uglifyOptions: { mangle: false }
      })
    );
  }

  return plugins;
}

const postcssLoader = {
  loader: "postcss-loader",
  options: {
    sourceMap: shouldOutputSourceMap(),
    plugins: function() {
      return [require("autoprefixer")];
    }
  }
};

const config = {
  devtool: determineDevtool(),
  context: CONTEXT_DIR,
  entry: { all: "./" + path.join(JAVASCRIPTS_PATH, "all.js") },
  resolve: {
    modules: [JAVASCRIPTS_DIR, STYLESHEETS_DIR, "node_modules"],
    extensions: [
      ".js",
      ".css",
      ".scss",
      ".eot",
      ".otf",
      ".ttf",
      ".woff",
      ".woff2"
    ]
  },
  output: {
    path: path.resolve(TMP_DIR, "dist"),
    filename: path.join(PUBLIC_PATH, JAVASCRIPTS_PATH, "[name].bundle.js")
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader"
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({
          use: ["css-loader", postcssLoader],
          fallback: "style-loader"
        })
      },
      {
        test: /\.(scss|sass)$/,
        loader: ExtractTextPlugin.extract({
          use: [
            {
              loader: "css-loader",
              options: {
                sourceMap: shouldOutputSourceMap()
              }
            },
            postcssLoader,
            {
              loader: "sass-loader",
              options: {
                sourceMap: shouldOutputSourceMap(),
                includePaths: [bourbon.includePaths]
              }
            }
          ],
          fallback: "style-loader"
        })
      },
      {
        test: /\.(eot|otf|ttf|woff|woff2)$/,
        loader: "file-loader",
        options: {
          name: "[name].[ext]",
          publicPath: "../fonts/",
          outputPath: path.join(PUBLIC_PATH, FONTS_PATH, "/")
        }
      },
      {
        test: /\.svg$/,
        loader: "file-loader"
      }
    ]
  },
  plugins: determinePlugins()
};

module.exports = config;
