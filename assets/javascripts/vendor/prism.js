import Prism from "prismjs";

import diff from "../extensions/prism/diff";
import prompt from "../extensions/prism/diff";
import term from "../extensions/prism/diff";

diff(Prism);
prompt(Prism);
term(Prism);

export default Prism;
