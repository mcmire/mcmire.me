const board = $("<table>").attr("id", "board");
const body = $(document.body);
body.append(board);

for (var y = 0; y < 9; y++) {
  const row = $("<tr>");
  board.append(row);
  for (var x = 0; x < 9; x++) {
    const cell = $("<td>");
    row.append(cell);
  }
}
