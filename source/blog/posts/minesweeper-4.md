---
title: Making Minesweeper in JavaScript, Part 4
teaser: >
  In this post, we start to add the core game logic by revealing all cells when
  a mine is clicked.
date: 2020-01-01
tags: programming
---

[At this point][minesweeper-3], we are able to place mines onto the board and
show those mines when the game loads. Now we can start to get into more of the
core functionality. Remember that if the player clicks on a space on the board,
there are three possibilities or cases:

[minesweeper-3]: /blog/minesweeper-3

* If any of the space's neighbors are a mine, we count how many there are
  and uncover the space, displaying that number inside the space.
* If none of the space's neighbors are mines, we uncover the space, displaying
  no number inside. We also uncover any neighbors that have no mine neighbors
  themselves, then uncover *their* neighbors that have no mine neighbors, and we
  keep doing this until we can't do it anymore.
* If the space is a mine, then we uncover all of the mines and end the game
  immediately (by "freezing" the board and preventing any further interaction).

Take a moment to read over these. We want to keep things as simple as possible
as long as we can, so what can we work on next? The first case is not bad, but
it involves accessing other parts of the board to find all the spaces around a
certain space, which we don't have a convenient way to do right now. The second
case requires finding neighbors as well, then adds some kind of loop that is
likely complicated. The third case, however, is just right. We already know
about all the mines and we know how to uncover them. So now we need to figure
out how to make the board interactive.

But first, let's write some pseudocode so we have something to work with:

```
when a cell is clicked
  if the cell is a mine
    uncover all mines: add a "mine" class to each mine cell
    end game: when a cell is clicked, do nothing
```

If you look closely Note that there are two places 

Let's take another look at our JavaScript code:

``` javascript
const board = $("<table>").attr("id", "board");
const body = $(document.body);
body.append(board);

const mineLocations = [];
for (let i = 0; i < 10; i++) {
  const mineLocation = Math.floor(Math.random() * 80);
  mineLocations.push(mineLocation);
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
