// Generate board

var cellSize = 20;  // pixels
var boardLength = 9;  // number of rows and cells
var boardSize = (cellSize * boardLength);
var board = $("#board");

for (var y = 0; y < boardLength; y++) {
  var row = $('<tr>');
  for (var x = 0; x < boardLength; x++) {
    var cell = $('<td>');
    row.append(cell);
  }
  board.append(row);
}

board.css({
  width: boardSize + 'px',
  height: boardSize + 'px'
});
