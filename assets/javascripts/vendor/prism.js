import Prism from "prismjs";

import diff from "../extensions/prism/diff";
import prompt from "../extensions/prism/prompt";
import term from "../extensions/prism/term";

diff(Prism);
prompt(Prism);
term(Prism);

export default Prism;
