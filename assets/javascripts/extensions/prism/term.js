export default function term(Prism) {
  Prism.languages.term = {
    comment: {
      pattern: /^\$.+/,
      inside: {
        operator: /^\$/
      }
    }
  };
}
