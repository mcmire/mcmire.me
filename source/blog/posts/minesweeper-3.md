---
title: Making Minesweeper in JavaScript, Part 3
teaser: >
  In this post, we draw mines and distribute them randomly across the board.
date: 2020-01-01
tags: programming
---

In the [last post] we wrote code so that the visuals for Minesweeper are
generated via JavaScript when the page loads. This will be helpful later as it
will allow us to update the board visually as the player interacts with the
game.

[last post]: /blog/minesweeper-2/

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

<iframe height="300" width="100%" src="/blog/minesweeper-2-step-6/minesweeper.html" border="0"></iframe>

Now for something a little more interesting.

### Drawing mines

Since the game is all about revealing hidden mines, it seems that we ought to be
able to draw those mines when the appropriate time comes. There are a couple of
different ways to do this, but ultimately we need to use HTML, CSS, or both. To
make things simple for right now, we'll choose the CSS method. When we draw a
space on the board, if a mine is inside of a space, then we'll add a `mine`
class to the table cell associated with the space.

How do we add a class to a cell (or any HTML element, for that matter)?
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

This is a *diff*, a common way to represent changes to a piece of text. We're
adding a line to `minesweeper.js`, so we've indicated that by placing a plus
sign (`+`) at the beginning of the line. You should add this line to your copy
too.
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

[Here's][m3s2]{:target="_blank"} what we get:

[m3s2]: /blog/minesweeper-3-step-2/minesweeper.html

<iframe height="300" width="100%" src="/blog/minesweeper-3-step-1/minesweeper.html" border="0"></iframe>

### Distributing mines

Now every cell is a mine, but of course what we really need is to scatter them
across the board, putting them in random spots so that each gameplay is
different.

How would that work exactly? Well, we'd have to first start out with a list of
all of the possible places where mines could live -- in other words, all the
spaces on the board. Then, we'd place those spaces in a virtual hat and draw
from that hat ten times to give us ten spaces. To use those spaces to draw
mines, we'd modify the loop that draws cells, asking each cell if it corresponds
to one of the ten spaces determined previously. If the answer is yes, we'd add
the `mine` class to the cell, otherwise we'd leave the cell empty.

That's a good plan, but it begs the question: if we are drawing spaces from a
"hat" and checking through them as we build cells, just what *is* a space? It'd
be more accurate to say that it's a location -- something that allows us to
identify a particular space across the board.

If that's true, then we need some sort of value in code to represent a space's
location. What if we were to assign a number to each space? That would work,
although we would want to start from 0 instead of 1 (not only is it more common
in programming to do so, but it will come in handy later):

![board numbering](images/minesweeper-3/board-numbering.svg)
{:.image}

Note how the last location is not the number of total cells (81), but one less
(80).

Okay! Let's write some pseudocode to make these ideas more concrete:

```
define an empty array called "mineLocations"
repeating for 10 times:
  draw a number from a "hat" of numbers between 0 and 80
  add the number to the "mineLocations" array
```

Drawing a cell, then, would work like this:

```
if mineLocations includes cell's location
  cell.addClass("mine")
```

### Seeding the mine locations

Great! Now we can start writing the real code. Let's address the first piece.
Defining an empty array and adding a number to an array are easy enough, but
what about the drawing-from-a-hat bit? What we really need here is a random
number, and JavaScript gives us one function to achieve this:
[`Math.random`][math-random]{:target="_blank"}. This function returns a number
between 0 and 1 (excluding 1 itself):

[math-random]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random

``` prompt
> Math.random()
< 0.5057105947315927
> Math.random()
< 0.43924692114566244
> Math.random()
< 0.5794767991781664
```

Hmm. We need a wider range here. Is there some way we can customize the
function? Not directly, but we can use a little math: since 0 × any number is 0,
and 1 × any number is that number, we can multiply the number that `Math.random`
returns by 80 to get a number between 0 and 80 (excluding 80 itself):

``` prompt
> Math.random() * 80
< 34.609916103091635
> Math.random() * 80
< 71.31560224890487
> Math.random() * 80
< 22.572173263630866
```

Now in order to get whole numbers and not decimal numbers, we need to round down
the result, which we can do with the
[`Math.floor`][math-floor]{:target="_blank"} function. Putting everything
together, we end up with something like this:

[math-floor]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor

``` javascript
const mineLocations = [];
for (let i < 0; i < 10; i++) {
  const mineLocation = Math.floor(Math.random() * 80);
  mineLocations.push(mineLocation);
}
```

### Drawing cells

Now for the second piece. In order to determine whether a cell's location is one
of the `mineLocations`, we have to determine the cell's location first. It turns
out we already know how to do this: since we use a loop with a loop (via `for`)
in order to build the rows and columns of the board, we have two counters that
we are incrementing: `rowIndex` and `columnIndex`. You can think of `rowIndex`
as the Y-coordinate and `columnIndex` as the X-coordinate of a given cell:

``` javascript
for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
  // ...
  for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
    // ...
  }
}
```

So now we have a way to locate cells, but note how this is different from the
way we locate mines: a cell has two coordinates, whereas a mine has only one.
Doesn't that pose a problem? Not exactly. If we have the X- and Y- coordinates
for a cell, we can arrive at the mine location by multiplying the Y-coordinate
by 9, then adding the X-coordinate to the product. So we can start by defining
a variable:

``` javascript
const possibleMineLocation = (rowIndex * 9) + columnIndex;
```

Now we need to determine whether `mineLocations` includes
`possibleMineLocation`. `mineLocations` is an array, and that means it has an
`indexOf` method. As its name suggests, `indexOf` will return the *index*, or
location, of a value in an array; if it doesn't find the value, it returns -1.
We want to make sure that doesn't happen, so we can say:

``` javascript
if (mineLocations.indexOf(possibleMineLocation) !== -1) {
  cell.addClass("mine");
}
```

### All together

Now we can combine our changes and update `minesweeper.js`:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

+const mineLocations = [];
+for (let i = 0; i < 10; i++) {
+  const mineLocation = Math.floor(Math.random() * 80);
+  mineLocations.push(mineLocation);
+}
+
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const cell = $("<td>");
+    const possibleMineLocation = (rowIndex * 9) + columnIndex;
+    if (mineLocations.indexOf(possibleMineLocation) !== -1) {
+      cell.addClass("mine");
+    }
     row.append(cell);
   }
 }
```
{:data-no-overflow="true"}

Finally, let's [take a look][m3s2]{:target="blank"} at what we get:

[m3s2]: /blog/minesweeper-3-step-2/minesweeper.html

<iframe height="300" width="100%" src="/blog/minesweeper-3-step-2/minesweeper.html" border="0"></iframe>

What do you know -- it worked!

### What's next

Now that we have some rudimentary mines, the next step is to [add
interactivity][minesweeper-4] so that clicking on the board reveals mines.

[minesweeper-4]: /blog/minesweeper-4/

<div class="nav-wrapper">
  <div class="nav nav--left">
    <a href="/blog/minesweeper-2/">← Go back</a>
  </div>
  <div class="nav nav--right">
    <a href="/blog/minesweeper-4/">Continue →</a>
  </div>
</div>
