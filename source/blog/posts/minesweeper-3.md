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

And so far the game looks like this:

<iframe height="300" width="100%" src="minesweeper-2-step-6/minesweeper.html" border="0"></iframe>

Now for something a little more interesting.

### Drawing mines

Since the game is all about revealing hidden mines, it seems that we ought to be
able to draw those mines when the appropriate time comes. There are a couple of
different ways to do this, but ultimately we need to use HTML, CSS, or both. To
make things simple for right now, we will choose the CSS method. When we draw a
space on the board, if a mine is inside of a space, then we will add a `mine`
class to the table cell associated with the space.

How do we add a class to a cell, or any HTML element, for that matter?
Fortunately, jQuery has a built-in solution with the `addClass` method. We can
use it like so:

``` javascript
element.addClass("someClass");
```

So we'll begin by modifying our JavaScript code like this:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const cell = $("<td>");
+    cell.addClass("mine");
     row.append(cell);
   }
 }
```

This is a *diff*, a common way to represent changes to a piece of text. Lines
that begin with a plus sign (`+`) are ones that we've added. You should add them
too (but don't include the plus sign!). Lines that begin with a minus sign
(`-`), on the contrary, are those that we've removed, and you should remove them
as well.
{:.aside.aside--tip}

Now we'll update `minesweeper.css` so that mines appear as black cells, and so
that the hover effect that we'd previously placed on all cells only applies to
non-mine cells.

``` diff
 #board {
   height: 200px;
   left: 50%;
   margin-left: -100px;
   margin-top: -100px;
   position: absolute;
   top: 50%;
   width: 200px;
 }

 td {
   border: 1px solid black;
   cursor: pointer;
 }

-td:hover {
+td:not(.mine):hover {
   background-color: #ddd;
 }
+
+.mine {
+  background-color: black;
+}
```
{:data-no-overflow="true"}

[Here's](minesweeper-3-step-1/minesweeper.html){:target="_blank"} what we get:

<iframe height="300" width="100%" src="minesweeper-3-step-1/minesweeper.html" border="0"></iframe>

### Determining mines

Well, that doesn't look right. Every cell is now a mine, but really, only some
of them should be mines, and those mines should be dispersed over the board. In
fact, mines shouldn't be in the same places from game to game, but should show up
in different cells on each gameplay.

In order to achieve this, we can change our code so that whenever we add a cell
to the board, we ask a question, "Should that cell become a mine or not?", and
we assign the `mine` class based on the answer. That means we need an `if`
statement, and in pseudocode it would look something like this:

```
if (the cell should become a mine) {
  cell.addClass("mine");
}
```

The tricky part is, in order to change up the board from one game to the next,
the answer to "should a cell become a mine or not" should sometimes be yes and
sometimes be no. How do we implement the idea of "sometimes" in JavaScript? If
you think about it, we're effectively flipping a coin: heads means yes and tails
means no. Well, a coin may land on heads half the time and tails half the time
on average, but for any given flip, it's impossible to know ahead of time what's
going to happen -- at the end of the day, it's a *random* event. So we need
something that randomly gives us a `true` or `false` answer.

As it turns out, JavaScript has a function to give us randomness:
[`Math.random`][math-random]{:target="_blank"}. However, this function is a
little peculiar, as instead of returning `true` or `false`, it returns a random
decimal number between 0 and 1:

[math-random]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random 

``` prompt
> Math.random()
< 0.5057105947315927
> Math.random()
< 0.43924692114566244
> Math.random()
< 0.5794767991781664
> Math.random()
< 0.14856934326712845
> Math.random()
< 0.6210856505259816
```

That's not what we want -- or is it?

Can we represent "yes" and "no" using a number instead of `true` or `false`?
What if we defined "no" as the number 0 and "yes" as the number 1? If we drew a
number line, with 0 on one side and 1 on the other, and we placed all the
numbers we got back from `Math.random` on that line, we would see that they
would fall somewhere in between the two:

![random numbers](/images/minesweeper-3/random-numbers.svg)
{:.image}

We could then say that any number before the halfway point represents `false`
and any number after the halfway point represents `true`.

Armed with this information, we can come up with the following pseudocode:

```
number = choose a random number between 0 and 1

if (the number is greater than 0.5) {
  cell.addClass("mine");
}
```

Great. Now let's implement it!

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const cell = $("<td>");
+    if (Math.random() > 0.5) {
       cell.addClass("mine");
+    }
     row.append(cell);
   }
 }
```

That brings us to [this](minesweeper-3-step-2/minesweeper.html){:target="_blank"}:

<iframe height="300" width="100%" src="minesweeper-3-step-2/minesweeper.html" border="0"></iframe>

Try refreshing the page. Notice how the board looks different every time!

### Limiting the number of mines

That's great, but if we were to implement the game functionality right now, it
would be very hard to play, as we have way too many mines! According to the
game, we should only have ten.

So we need to restrict the number of mines that we place somehow. We might be
tempted to change our JavaScript to add some kind of counter to keep track of
the number of mines as we place them:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

+let numberOfMines = 0;
+
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const cell = $("<td>");
-    if (Math.random() > 0.5) {
+    if (Math.random() > 0.5 && numberOfMines < 10) {
       cell.addClass("mine");
+      numberOfMines++;
     }
     row.append(cell);
   }
 }
```
{:data-no-overflow="true"}

And technically, [this](minesweeper-3-step-3/minesweeper.html){:target="_blank"}
would work:

<iframe height="300" width="100%" src="minesweeper-3-step-3/minesweeper.html" border="0"></iframe>

But notice how all of the mines are now clumped together in one place. Can you
tell why this is happening? There doesn't seem to be enough randomness here.
How can we make those mines more dispersed?

Look back at the number line we drew above. We are saying that whenever a number
between 0.5 and 1 is chosen at random, our cell should turn into a mine. This is
half of the numbers between 0 and 1, so there's a 50% chance that the cell will
turn into a mine and a 50% chance that it will stay a cell. What if we were to
change the range of numbers we are choosing among? If we slid the start of the
range up to 0.8, then since this is 20% of the available numbers, there would be
a 20% chance that the cell turned into a mine and an 80% chance that the cell
stayed a cell. So we can change our code as follows:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

 let numberOfMines = 0;

 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const cell = $("<td>");
-    if (Math.random() > 0.5 && numberOfMines < 10) {
+    if (Math.random() > 0.8 && numberOfMines < 10) {
       cell.addClass("mine");
       numberOfMines++;
     }
     row.append(cell);
   }
 }
```
{:data-no-overflow="true"}

Now let's [take a look](minesweeper-3-step-4/minesweeper.html){:target="_blank"}
at what this gives us:

<iframe height="300" width="100%" src="minesweeper-3-step-4/minesweeper.html" border="0"></iframe>

That's looking a lot better.

### A cleaner approach

But let's take a moment to pause here. We want to distribute mines across the
board in a different way each time; we don't want them to be in the same corner
every gameplay. The fact that we had to fine-tune the probability that a cell
turns into a mine in order to achieve this raises a bit of a red flag.

To illustrate why, we've made an interactive version of the board. We've drawn a
box around the area that all of the mines cover. The slider represents the
probability as a percentage. What happens to the box when you move it?

[interactive board here]

When the probability is small, the area that we consider when placing mines is
small. When the probability is large, 

We know that if the "chance of mine" is 50%, then all of the mines appear close
together at the start of the board. In other words, the area that contains the
mines is very small. What happened when we lowered the probability? The
contained area grew bigger.

We've illustrated this concept below. Move the slider to adjust the number that
represents the "chance of mine" and notice what happens. What number would you
choose to ensure that mines are spread out across the board?


How did you choose which number to use? 

If you found that the best-looking probability is the one where the mine area is
the whole board, you're on the right track here.

Now for a wrinkle. Let

We are making the assumption that our board is 9x9. But what if it



Now, in our code, what probability should we ultimately choose? We chose 20%

Here's the wrinkle: by using this approach, we're making the assumption that the
board will always be the same size (9x9). After all, what if the board were
bigger? What probability would we have to choose to cover the board in mines?
Move the sliders below and try it out for yourself:



tells us that our approach is "brittle" -- if 


doesn't fit
the problem in a scalable way. 

What effect did changing the probability
of a cell becoming a mine have on our board?

isn't it a little funny that we had to play with the
probability like that?

Let's take another look at what done so far. We started
with a idea:

* As we build cells, "flip a coin" to determine whether the cell is a mine
* Keep a tally of the number of mines as we create them and stop turning cells
  into mines when the number reaches 10

When you flip a coin, there is an equal (50%) chance that you will end up with
heads or tails. In the same way, for each cell, there is a 50% chance that it
could become a mine. We had to decrease the chance that a cell becomes a mine
from 50% to 20%. But when we implemented this approach, we found that the logic
that "flips a coin" didn't place the mines correctly.

it doesn't fit the problem perfectly. 

That kind of works, but if you refresh a few times, you may notice that some of
the mines are still clumped together. Plus, our code is starting to look messy.
Look at how many things our loop is doing: not only is it concerned with
building HTML elements and adding them to the screen, but it's also concerned
with determining whether a cell is a mine, as well as keeping track of how many
mines exist. Perhaps there's another approach that we can take here.

### Determine mines ahead of time

<iframe height="300" width="100%" src="minesweeper-3-step-5/minesweeper.html" border="0"></iframe>

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
