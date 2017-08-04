const board = $("<table>").attr("id", "board");
const body = $(document.body);
body.append(board);

const mineLocations = [];
for (let i = 0; i < 10; i++) {
  // TODO: Fix me so this is unique
  const mineLocation = Math.floor(Math.random() * 80);
  mineLocations.push(mineLocation);
}

const mines = [];

for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
  const row = $("<tr>");
  board.append(row);
  for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
    const space = $("<td>");
    const possibleMineLocation = (rowIndex * 9) + columnIndex;
    const isMine = (mineLocations.indexOf(possibleMineLocation) !== -1);

    if (isMine) {
      mines.push(space);
    }

    row.append(space);

    space.on("click", () => {
      if (isMine) {
        mines.forEach(mine => {
          mine.addClass("mine");
        });
      }
    });
  }
}
