import Prism from "prismjs";

import bash from "../extensions/prism/bash";
import diff from "../extensions/prism/diff";
import prompt from "../extensions/prism/prompt";
import term from "../extensions/prism/term";

bash(Prism);
diff(Prism);
prompt(Prism);
term(Prism);

export default Prism;
