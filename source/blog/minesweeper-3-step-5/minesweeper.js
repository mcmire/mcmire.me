// Set some globals

let boardLength = 9;  // number of rows and cells
let totalNumberOfCells = boardLength * boardLength;
let numberOfMines = 10;
const board = $("<table>").attr("id", "board");
const body = $(document.body);
body.append(board);

// Generate mines

let mines = [];
for (let i = 0; i < numberOfMines; i++) {
  let mine = Math.floor(Math.random() * totalNumberOfCells);
  mines.push(mine);
}

// Generate board

for (let y = 0; y < boardLength; y++) {
  let row = $('<tr>');
  for (let x = 0; x < boardLength; x++) {
    let cell = $('<td>');

    // Determine whether cell is a mine
    if (mines.indexOf((y * boardLength) + x) !== -1) {
      cell.addClass('mine');
    }

    row.append(cell);
  }
  board.append(row);
}
