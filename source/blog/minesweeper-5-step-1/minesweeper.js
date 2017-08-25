const board = $("<table>").attr("id", "board");
const body = $(document.body);
body.append(board);

const hatOfMineLocations = [];
for (let n = 0; n <= 80; n++) {
  hatOfMineLocations.push(n);
}

const mineLocations = [];
for (let i = 0; i < 10; i++) {
 const mineLocationIndex = Math.floor(Math.random() * hatOfMineLocations.length);
 const mineLocation = hatOfMineLocations[mineLocationIndex];
 mineLocations.push(mineLocation);
 hatOfMineLocations.splice(mineLocationIndex, 1);
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
      space.addClass("mine");
    }

    row.append(space);

    space.on("click", () => {
      if (isMine) {
        mines.forEach(mine => {
          mine.addClass("uncovered");
        });
      }
    });
  }
}
