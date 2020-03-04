export default function term(Prism) {
  Prism.languages.term = {
    prompt: {
      pattern: /^\$.+/m,
      inside: {
        selector: {
          pattern: /^\$/
        }
      }
    }
  };
}
