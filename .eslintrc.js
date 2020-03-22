module.exports = {
  "env": {
    "browser": true,
    "node": true,
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 2018,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true,
    },
  },
  "plugins": [
    "prettier",
  ],
  "rules": {
    "prettier/prettier": "error",
  },
}
