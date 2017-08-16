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

for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
  const row = $("<tr>");
  board.append(row);
  for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
    const cell = $("<td>");
    const possibleMineLocation = (rowIndex * 9) + columnIndex;
    if (mineLocations.indexOf(possibleMineLocation) !== -1) {
      cell.addClass("mine");
    }
    row.append(cell);
  }
}
