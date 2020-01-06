---
title: "Building Minesweeper in JavaScript: Part 4"
teaser: >
  In this post, we start to add the core game logic by revealing all spaces when
  a mine is clicked.
date: 2020-01-04
tags: programming
---

[At this point][minesweeper-3], we are able to place mines onto the board and
show those mines when the game loads. Now we can start to get into more of the
core functionality. Remember that if the player clicks on a space on the board,
there are three things that can happen:

[minesweeper-3]: /blog/minesweeper-3

* If any of the spaces surrounding the space is a mine, we count how many there
  are and uncover the space, displaying that number inside the space.
* If none of the surrounding spaces are mines, we uncover the space, displaying
  no number inside. We also uncover any surrounding spaces that have no
  surrounding mines themselves, then uncover *their* surrounding spaces that
  have no surrounding mines, and so forth and so on.
* If the space is a mine, then we uncover all of the mines.

Take a moment to read over these. We want to keep things as simple as possible
as long as we can, so what can we work on next?

* The first case is not bad, but it involves accessing other parts of the board
  to find all the spaces around a certain space, which we don't have a
  convenient way to do right now.
* The second case requires finding surrounding spaces as well, then adds some
  kind of loop that seems complicated.
* The **third case**, however, is just right. We already know about all the
  mines and we know how to uncover them. So now we need to figure out how to
  make the board interactive.

### Plan of attack

As before, let's start by writing some pseudocode so we have something to work
with:

* When a space is clicked
  * If the space is a mine
    * **Uncover all mines:** Add a "mine" class to each mine space
{:.pseudocode}

We'll take another look at our JavaScript code:

``` javascript
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
```

At the moment we are showing all of the mines up front. We want to keep some
part of this code, but we're not sure where to put it. So let's comment it out
for now:

``` diff
 ...
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const space = $("<td>");
     const possibleMineLocation = (rowIndex * 9) + columnIndex;
-    if (mineLocations.indexOf(possibleMineLocation) !== -1) {
-      space.addClass("mine");
-    }
+    // if (mineLocations.indexOf(possibleMineLocation) !== -1) {
+    //   space.addClass("mine");
+    // }
     row.append(space);
   }
 }
```
{:data-no-overflow="true"}

Now we need to make space for our new code. We know that we want to do something
"when a space is clicked". That tells us that the new code is specific to a `td`
element, so it seems that a good place is inside the second loop. Let's stick
our pseudocode there, commenting it out so it serves as a placeholder:

``` diff
 ...
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const space = $("<td>");
     const possibleMineLocation = (rowIndex * 9) + columnIndex;
     // if (mineLocations.indexOf(possibleMineLocation) !== -1) {
     //   space.addClass("mine");
     // }
     row.append(space);
+
+    // NEW CODE GOES HERE:
+    // when a space is clicked
+    //   if the space is a mine
+    //     uncover all mines: add a "mine" class to each mine space
   }
 }
```
{:data-no-overflow="true"}

Here's a question: How do we something when an element gets clicked? It may seem
that we need an `if` statement. But that wouldn't work, as that would assume
that the click has happened already and that it will only happen once. So what
do we do?

### Adding an event listener

Imagine that your car is having trouble. You make your way to the mechanic,
describe the problem to the person at the front desk, and leave your car for the
shop to work on. When they are finished, what happens? They call you back and
tell you that it's ready to be picked up.

It turns out that this is a common pattern in programming. You have something
you're waiting for, the *event*. You associate the event with a *callback*,
some piece of code which will be run when the event occurs. To put it in
JavaScript terms, you *listen* for the event to take place, and you respond to
that event using an *event listener*.

So when a user clicks on a space, the browser will generate a `click` event on
the `td` element that represents the space. That means we need to listen to it
somehow. Enter jQuery again! Handily, it gives us an an `on` method that we can
use like this:

``` diff
 ...
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const space = $("<td>");
     const possibleMineLocation = (rowIndex * 9) + columnIndex;
     // if (mineLocations.indexOf(possibleMineLocation) !== -1) {
     //   space.addClass("mine");
     // }
     row.append(space);

-    // NEW CODE GOES HERE:
-    // when a space is clicked
-    //   if the space is a mine
-    //     uncover all mines: add a "mine" class to each mine space
-    //     end game: when a space is clicked, do nothing
+    space.on("click", () => {
+      // if the space is a mine
+      //   uncover all mines: add a "mine" class to each mine space
+    }
   }
 }
```
{:data-no-overflow="true"}

Here we're calling `on` with the name of the event, `"click"`. This registers an
event listener, which is a JavaScript function.

Wait, where's the function we're passing to `on`? Here we're using the "fat
arrow" syntax (`() => { ... }` vs. `function () { ... }`). This may look funny,
but it's often used when passing a function as an argument to another function
like this. The formal name for this style is an *arrow function*, and you can
learn all about them and what they do [here][arrow-functions].
{:.aside.aside--tip}

[arrow-functions]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions#Arrow_functions

### Uncovering mines

Now it's up to us to decide what we want to do inside of our function. We know
we need to uncover all of the mines. This may seem easy: we already have a list
of mines and we already know how to uncover one mine by adding a `mine` class to
it. Can't we loop through the mines and add the `mine` class to each one?

Except we don't have a list of mines -- we have a list of mine *locations*. And
to uncover a mine, we need access to a `td` element. So what we really need to
do is loop through a list of `td` elements that correspond to mines. This proves
a bit challenging, since we don't have such a list. But we can make one!

We'll initialize an array at the beginning, and as we build spaces, we'll add
the space to the array if we determine it's a mine. Let's try that:

``` diff
 const board = $("<table>").attr("id", "board");
 const body = $(document.body);
 body.append(board);

 const mineLocations = [];
 for (let i = 0; i < 10; i++) {
   const mineLocation = Math.floor(Math.random() * 80);
   mineLocations.push(mineLocation);
 }

+const mines = [];
+
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const space = $("<td>");
     const possibleMineLocation = (rowIndex * 9) + columnIndex;
-    // if (mineLocations.indexOf(possibleMineLocation) !== -1) {
-    //   space.addClass("mine");
-    // }
+    if (mineLocations.indexOf(possibleMineLocation) !== -1) {
+      mines.push(space);
+    }
     row.append(space);

     space.on("click", () => {
       // if the space is a mine
       //   uncover all mines: add a "mine" class to each mine space
     }
   }
 }
```
{:data-no-overflow="true"}

Now we can uncover all the mines:

``` diff
 ...
 for (let rowIndex = 0; rowIndex < 9; rowIndex++) {
   const row = $("<tr>");
   board.append(row);
   for (let columnIndex = 0; columnIndex < 9; columnIndex++) {
     const space = $("<td>");
     const possibleMineLocation = (rowIndex * 9) + columnIndex;
+    const isMine = (mineLocations.indexOf(possibleMineLocation) !== -1);
+
-    if (mineLocations.indexOf(possibleMineLocation) !== -1) {
+    if (isMine) {
       mines.push(space);
     }
+
     row.append(space);

     space.on("click", () => {
-      // if the space is a mine
-      //   uncover all mines: add a "mine" class to each mine space
+      if (isMine) {
+        mines.forEach(mine => {
+          mine.addClass("mine");
+        });
+      }
     }
   }
 }
```
{:data-no-overflow="true"}

Great! Let's [see][minesweeper-4-step-1]{:target="_blank"} what that looks like.
Try clicking around until you hit a mine! (For demonstration purposes, we've
highlighted them in red on hover.)

<iframe src="/blog/minesweeper-4-step-1/minesweeper.html"></iframe>

[minesweeper-4-step-1]: /blog/minesweeper-4-step-1/minesweeper.html

### What's next

Next we'll tackle the next simplest outcome: [what happens][minesweeper-5] when
a space that *isn't* a mine, yet is near one, is uncovered.

[minesweeper-5]: /blog/minesweeper-5/

<div class="nav-wrapper">
  <div class="nav nav--left">
    <a href="/blog/minesweeper-3/">← Go back</a>
  </div>
  <div class="nav nav--right">
    <a href="/blog/minesweeper-5/">Continue →</a>
  </div>
</div>
