const board = $("<table>").attr("id", "board");
const body = $(document.body);
body.append(board);

for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
  const row = $("<tr>");
  board.append(row);
  for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
    const cell = $("<td>");
    row.append(cell);
  }
}
