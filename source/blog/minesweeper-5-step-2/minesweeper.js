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
const spaces = [];

for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
  const row = $("<tr>");

  board.append(row);
  spaces[rowIndex] = [];

  for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
    const space = $("<td>");
    const possibleMineLocation = (rowIndex * 9) + columnIndex;
    const isMine = (mineLocations.indexOf(possibleMineLocation) !== -1);

    if (isMine) {
      mines.push(space);
      space.addClass("mine");
      space.data("isMine", true);
    }

    spaces[rowIndex][columnIndex] = space;

    row.append(space);

    space.on("click", () => {
      if (isMine) {
        mines.forEach(mine => {
          mine.addClass("uncovered");
        });
      } else {
        const previousRow = spaces[rowIndex - 1] || [];
        const nextRow = spaces[rowIndex + 1] || [];
        const currentRow = spaces[rowIndex];
        const neighborsWithPossibleNulls = [
          currentRow[columnIndex - 1],
          currentRow[columnIndex + 1],
          previousRow[columnIndex - 1],
          previousRow[columnIndex],
          previousRow[columnIndex + 1],
          nextRow[columnIndex - 1],
          nextRow[columnIndex],
          nextRow[columnIndex + 1]
        ];
        const neighbors = neighborsWithPossibleNulls.filter(neighbor => {
          return neighbor != null;
        });
        const neighboringMines = neighbors.filter(neighbor => {
          return neighbor.data("isMine");
        });
        const numNeighboringMines = neighboringMines.length;

        if (numNeighboringMines > 0) {
          space.addClass("uncovered");
          space.text(numNeighboringMines);
        }
      }
    });
  }
}
