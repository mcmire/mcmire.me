export default function diff(Prism) {
  Prism.languages.diff = {
    coord: [
      // Match all kinds of coord lines (prefixed by "+++", "---" or "***").
      /^(?:\*{3}|-{3}|\+{3}).*$/m,
      // Match "@@ ... @@" coord lines in unified diff.
      /^@@.*@@$/m,
      // Match coord lines in normal diff (starts with a number).
      /^\d+.*$/m
    ],
    // Match inserted and deleted lines. Support both +/- and >/< styles.
    deleted: {
      pattern: /^[-<].*$/m,
      inside: {
        marker: /^[-<]/
      }
    },
    inserted: {
      pattern: /^[+>].*$/m,
      inside: {
        marker: /^[+>]/
      }
    },
    // Match "different" lines (prefixed with "!") in context diff.
    diff: {
      pattern: /^!(?!!).+$/m,
      alias: "important"
    },
    unchanged: {
      pattern: /^(.+)$/m,
      inside: {
        marker: /^[ ]+/
      }
    }
  };
}
