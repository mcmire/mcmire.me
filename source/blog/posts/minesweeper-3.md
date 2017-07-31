---
title: Making Minesweeper in JavaScript, Part 3
teaser: >
  We mark cells as mines.
date: 2020-01-01
tags: programming
---

In the [last post] we wrote code so that the visuals for Minesweeper are
generated via JavaScript when the page loads. This will be helpful later as it
will allow us to update the board visually as the player interacts with the
game.

[last post]: minesweeper-2

Let's review what we have in our project so far:

<ul class="file-tree">
  <li class="directory"><span>minesweeper/</span><ul>
      <li class="file">minesweeper.html</li>
      <li class="file">minesweeper.css</li>
      <li class="file">jquery.js</li>
      <li class="file">minesweeper.js</li>
    </ul>
  </li>
</ul>

Our `minesweeper.js` looks like this:

``` javascript
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
```

Now for the next part. Since the game is all about revealing hidden mines, the
first problem we have is to figure out how to designate mines. Some of the
spaces will be mines and some won't, and the ones we've designated will change
from game to game. Once we've established where the mines are, the second
problem is to determine how to redraw those spaces as mines at the appropriate
time. There are a couple of different ways to do this, but ultimately we need to
use HTML, CSS, or both. Since spaces are cells in our table, to make things
simple for right now, we will settle on this definition: a mine is a cell that
has a `mine` class and a non-mine is a cell that doesn't.

Let's tackle the second problem first. How do we assign a cell a class?
Fortunately, jQuery has a built-in solution:

``` javascript
cell.addClass("cell");
```

So we can start by modifying our JavaScript code like so:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

 for (var y = 0; y < 9; y++) {
   const row = $("<tr>");
   board.append(row);
   for (var x = 0; x < 9; x++) {
     const cell = $("<td>");
+    cell.addClass("mine");
     row.append(cell);
   }
 }
```

What you see here is a way to represent changes to a particular piece of text.
The exact format we're using is called a *diff* and it is commonly used. Added
lines are indicated with a plus sign (`+`) at the beginning of them; deleted
lines are indicated with a minus sign (`-`).
{:.tip}

This will add a `mine` class to every cell, but of course, that's not quite what
we want. We said earlier that the mines we've designated will change from game
to game. Some of the cells will be mines in one game, and others will be mines
in another game. So when we add a cell to the board, we have to make a choice:
should that cell become a mine or not? The tricky part is that sometimes we need
the answer to be yes and sometimes we need it to be no. Effectively, we are
flipping a coin. How do we translate this idea into JavaScript?

Well, there are two parts to this. First, we need to represent "yes" or "no".
Usually in programming we would use a *boolean* value: `true` or `false`. Okay,
so what about that "sometimes" bit? Given that we don't know what the answer
will be ahead of time, we need to introduce *randomness* into our code. As it
turns out, JavaScript has a function to give us this:
[`Math.random`][math-random]. However, this function is a little peculiar, as
instead of returning `true` or `false`, it returns a random decimal between 0
and 1:

[math-random]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random 

```
> Math.random()
0.5057105947315927
Math.random()
0.43924692114566244
Math.random()
0.5794767991781664
Math.random()
0.14856934326712845
Math.random()
0.6210856505259816
```

That's not what we want -- or is it?

Can we represent "yes" and "no" using a number instead of a boolean? What if we
defined "no" as the number 0 and "yes" as the number 1? If we drew a number
line, with 0 on one side and 1 on the other, and we placed all the numbers we
got back from `Math.random` on that line, we would see that they would fall
somewhere in between the two:

```
|------------------------------------------------------------------------------|
0       |                    |        |     |       |                          1
        ` 0.1486             ` 0.4392 ` 0.5057       ` 0.6211
                                            ` 0.5795
```

We could then say that any number before the halfway point represents `false`
and any number after the halfway point represents `true`.

Armed with this information, we can come up with the following pseudocode:

```
number = choose a random number between 0 and 1

if the number is greater than 0.5
  add the mine class to the cell
else
  don't worry about it
```

Now we can modify our code:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

 for (var y = 0; y < 9; y++) {
   const row = $("<tr>");
   board.append(row);
   for (var x = 0; x < 9; x++) {
     const cell = $("<td>");
+    if (Math.random() > 0.5) {
       cell.addClass("mine");
+    }
     row.append(cell);
   }
 }
```

----

**OLD STUFF**

```
if a cell is a mine
  make a cell a mine
```

``` diff
 for (var y = 0; y < 9; y++) {
   const row = $("<tr>");
   board.append(row);
   for (var x = 0; x < 9; x++) {
     const cell = $("<td>");
+
+    if (cell
     row.append(cell);
   }
 }
```

1. How do we choose which spaces are mines and which ones aren't?
1. How do we distinguish the two visually?

Where are the 


we don't have to do much at all: we can simply
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
