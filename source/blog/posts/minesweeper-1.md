---
title: Making Minesweeper in JavaScript, Part 1
teaser: >
  In the first post in this series,
  we introduce the project
  and start by making a simple board.
date: 2020-01-01
tags: programming
---

If you owned a PC 15 years ago, you might remember Minesweeper. It's one of the
classic Windows games and was bundled along with other diversions such as
Solitaire, Pegged, Taipei, and the like.

In this post and the next several posts, we're going to be building Minesweeper
in JavaScript. We're going to start by writing very procedural code using
jQuery, proceed by removing jQuery and adding more abstraction, and close by
experimenting with ways we can implement Minesweeper using other frameworks and
languages.

### The game

![Microsoft Minesweeper][ms-minesweeper]
{:class="image"}

The game is simple. It's played on a grid of spaces, typically 9 long and 9
wide. There are 10 mines hidden at random spaces within the grid. The player
uncovers spaces by clicking on them. There are then three possibilities
depending on the state of the space:

* If there are any mines adjacent to the space, the space is said to be
  "dangerous". It is marked as uncovered in some way (typically by pushing in
  that space visually), and the number of mines is shown within the space.
* If there are no mines adjacent to the space, the space is said to be "safe".
  It is marked as uncovered, and if any of the adjacent spaces aren't mines,
  they are uncovered, and *their* adjacent non-mine spaces are uncovered, and
  this continues recursively until a perimeter of dangerous spaces have been
  uncovered.
* Finally, if the space is a mine, then all of the spaces are uncovered
  (including other mines), and the game is over.

The player wins, then, by managing to uncover all spaces without blowing up.

[ms-minesweeper]: http://assets.mcmire.me/posts/2015-08-14-minesweeper-1/ms-minesweeper.png

### Starting small

We'll start with two files:

* *minesweeper.html*
* *minesweeper.css*

Judging by the screenshot above, we'll need to render a grid of cells. There are
multiple ways to do this, but we don't want to have to right a bunch of CSS
right now, so let's go with tables for now. Here's *minesweeper.html*:

``` html
<!DOCTYPE html>
 
<html>
  <head>
    <title>Minesweeper</title>
    <link rel="stylesheet" href="game.css">
    <script src="game.js"></script>
  </head>
 
  <body>
    <table id="board">
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
    </table>
  </body>
</html>
```

We'll also sprinkle a few styles on top. We set the board to a reasonable size,
and add some visual feedback to each cell when it's hovered over. Here's
*minesweeper.css*:

``` css
#board {
  width: 400px;
  height: 400px;
}
 
td {
  border: 1px solid black;
  cursor: pointer;
}
 
td:hover {
  background-color: #ddd;
}
```

The board doesn't do a whole lot yet, but here's what it looks like so far:

<iframe height="300" width="100%" src="minesweeper.html" border="0"></iframe>

In the next post, we'll add jQuery, populate the board with mines, and reveal
cells when they are clicked. Stay tuned!
