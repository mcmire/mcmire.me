---
title: Making Minesweeper in JavaScript, Part 3
teaser: >
  In this post, we add mines.
date: 2020-01-01
tags: programming
---

### Cleaning up the code a bit

``` javascript
var cellSize = 50;  // pixels
var boardLength = 9;  // number of rows and cells
var boardSize = (cellSize * boardLength);
var board = $("#board");

for (var y = 0; y < boardLength; y++) {
  var row = $("<tr>");
  for (var x = 0; x < boardLength; x++) {
    var cell = $("<td>");
    row.append(cell);
  }
  board.append(row);
}

board.css({
  width: boardSize + "px",
  height: boardSize + "px"
});
```

### Marking cells as mines

Right now, you can hover over cells, but that's it -- not particularly exciting.
So what's the next step?

A core feature of Minesweeper is the fact that certain cells are designated as
mines. We can ask ourselves two questions:

1. How do we choose which cells are mines and which ones aren't?
1. How do we distinguish the two visually?

To choose which cells are mines, we don't have to do much at all: we can simply
place them at random places on the board. So we'll start by generating a list of
possible places that mine could be. Then, as we are building up the HTML to
represent the board, whenever we add a cell, we'll ask if that cell is in fact a
mine; if it is, we'll apply a CSS class to the cell element.

``` diff
--- a/minesweeper.js
+++ b/minesweeper.js
@@ -1,14 +1,32 @@
 var cellSize = 50;  // pixels
 var boardLength = 9;  // number of rows and cells
 var boardSize = (cellSize * boardLength);
 var board = $("#board");
+
+//var mines = ... generate mines somehow?? ...
+
 for (var y = 0; y < boardLength; y++) {
   var row = $("<tr>");
   for (var x = 0; x < boardLength; x++) {
     var cell = $("<td>");
+
+    //if (cell is somehow a part of mines) {
+    //  cell.addClass("mine");
+    //}
+
     row.append(cell);
   }
 }

 board.append(row);
```

That leads us to another question: how do we know where the mines are, and how
are we able to tell whether a cell is a mine? It seems that we need some way of
designating the *location* of any cell on the board, including mines. Then, what
we could do is compare the location of a cell (as we are adding it to the board)
to the location of a known mine (that we've determined ahead of time). If the
locations match, then the cell is a mine.

Okay, so what's the easiest way to designate the location of a cell? Let's use a
number. 0 would represent the first cell in the first row, and the total number
of cells (minus 1) would represent the last cell in the last row. Since there
are 10 mines in the original game, 10 of those numbers -- again, chosen at
random -- would represent mines. So if our board had 300 cells in total, then
the locations for all cells would range from 0 to 299, and possible locations
for mines could be 13, 29, 45, 63, 109, 134, 158, 167, 199, and 213.

``` diff
--- a/minesweeper.js
+++ b/minesweeper.js
@@ -1,14 +1,32 @@
 var cellSize = 50;  // pixels
 var boardLength = 9;  // number of rows and cells
 var boardSize = (cellSize * boardLength);
+var totalNumberOfCells = boardLength * boardLength;
+var numberOfMines = 10;
  var board = $("#board");
+
+var mines = [];
+for (var i = 0; i < numberOfMines; i++) {
+  var mine = Math.floor(Math.random() * totalNumberOfCells);
+  mines.push(mine);
+}
+
 for (var y = 0; y < boardLength; y++) {
   var row = $("<tr>");
   for (var x = 0; x < boardLength; x++) {
     var cell = $("<td>");
 
     //if (cell is somehow a part of mines) {
     //  cell.addClass("mine");
     //}
 
     row.append(cell);
   }
 }

 board.append(row);
```

Now we need a way to use `mines` to determine whether a given cell shares a
location with that of a mine. We said that a location of a cell can be
represented by a single number between 0 and the total number of cells minus 1.
However, it can also be represented by two numbers: row and column. We have this
information in the code -- in fact, it's the `x` and `y` variables that we set
in order to create each row and column to form the grid. How do we correlate our
`x` and `y` coordinates with the numbers in `mines`?

We can take advantage of the fact that to get from the first cell in the first
row to the first cell in the second row we have to walk through each of the
cells in the first row.

``` diff
--- a/minesweeper.js
+++ b/minesweeper.js
@@ -1,14 +1,32 @@
 var cellSize = 50;  // pixels
 var boardLength = 9;  // number of rows and cells
 var boardSize = (cellSize * boardLength);
 var totalNumberOfCells = boardLength * boardLength;
 var numberOfMines = 10;
 var board = $("#board");

 var mines = [];
 for (var i = 0; i < numberOfMines; i++) {
   var mine = Math.floor(Math.random() * totalNumberOfCells);
   mines.push(mine);
 }
 
 for (var y = 0; y < boardLength; y++) {
   var row = $("<tr>");
   for (var x = 0; x < boardLength; x++) {
     var cell = $("<td>");

-    //if (cell is somehow a part of mines) {
+    if (mines.indexOf((y * boardLength) + x) !== -1) {
       cell.addClass("mine");
     }
 
     row.append(cell);
   }
   board.append(row);
```
