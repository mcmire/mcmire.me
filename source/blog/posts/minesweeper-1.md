---
title: Making Minesweeper in JavaScript, Part 1
teaser: >
  In the first post in this series, we introduce the project by making a simple
  board.
date: 2020-01-01
tags: programming
---

It's no secret that JavaScript is a very important part of the web. It's been
around for over 20 years, and as the Internet has expanded and evolved,
JavaScript has quietly gained some serious muscle to take on larger roles. Time
was that you'd only use the language to add gimmicks like falling snowflakes to
your pages; now you can use it to build apps that run on your phone. Within the
past 7 years alone, we've seen a major explosion of growth in the JavaScript
ecosystem as the language itself has received much-needed modernizations and as
power tools like Ember, Angular, and React have enabled people to do more with
less. There are almost a half a million JavaScript modules that people have
written and published to the larger community, and the number is constantly
growing.

Since JavaScript has been around for so long, if you are learning web
development or trying to brush on on your skills, you're in luck, because there
are resources left and right at your fingertips. But that choice comes at a
price: it can be difficult to find a foothold that will allow you to pull
yourself along and gain real progress. And while the JavaScript community is
busy taking the language to new heights, I feel that they've left the
fundamentals in the dust.

That's why, in this series of blog posts, we're going to work on a small project
-- something that we can finish in a reasonable amount of time, that will
demonstrate some of the key basics in using JavaScript for modern web
development, and that will give us a platform we can use to experiment with
newer technologies.

![Microsoft Minesweeper][ms-minesweeper]
{:class="floating-image"}

[ms-minesweeper]: http://assets.mcmire.me/posts/2015-08-14-minesweeper-1/ms-minesweeper.png

What we'll be making is a game called [Minesweeper]. You may have heard of it --
for a long time, it was included on every Windows computer (along with FreeCell,
3D Pinball, and others). Even if you are unfamiliar with the game, it's a good
choice because the rules are simple and there are no animations, real-time play
or complicated logic. Here are the topics we'll cover:

[Minesweeper]: https://en.wikipedia.org/wiki/Microsoft_Minesweeper

* Using HTML and CSS to display the board
* Using [jQuery][]{:target="_blank} to render the board dynamically
* Organizing code into functions
* Using the [JavaScript DOM API][]{:target="_blank"} in favor of jQuery
* Splitting the game logic and data from the display code
* Substituting the view layer with React
* Re-engineering the game using Ember and Angular

[jQuery]: http://jquery.com
[JavaScript DOM API]: https://www.w3.org/TR/html51/dom.html

Before we begin, there are a few things that you should know. First, since this
is a series focusing on JavaScript, you should already have some understanding
of HTML and CSS. ([Khan Academy][intro-to-html-and-css]{:target="_blank"}
provides a good overview if you need to brush up on your skills.) Second,
although it's not absolutely required, it would help if you have a basic
understanding of JavaScript already -- variables, functions, and the like.
(Again, [Khan Academy][intro-to-javascript]{:target="_blank"} is a good
resource.) Finally, as we progress I'm going to be providing all of the code,
and you are free to just peruse if you like, but you're going to learn a lot
more if you do the work yourself. I don't want you copying and pasting! You
should write everything out by hand as I give it to you so that you have an
opportunity to internalize it. That means that you should already be using a
editor such as [Atom][]{:target="_blank"} to write code.

[intro-to-html-and-css]: https://www.khanacademy.org/computing/computer-programming/html-css
[intro-to-javascript]: https://www.khanacademy.org/computing/computer-programming/programming
[Atom]: https://atom.io/

Let's get down to it.

### The game

Minesweeper is played on a board of spaces, typically 9 long and 9 wide. Across
the board there are mines hidden within 10 random spaces. When the game starts,
all of the spaces appear the same, and the player uncovers the true identity of
a space by clicking on it. The space is marked in some way visually -- typically
by pushing it in -- and then there are then three possibilities depending on the
state of the space:

* If there are any mines adjacent to the space, it is said to be "dangerous".
  The number of mines is shown within the space.
* If there are no mines adjacent to the space, the space is said to be "safe".
  These spaces are uncovered, and *their* adjacent non-mine spaces are
  uncovered, and this continues recursively until a perimeter of dangerous
  spaces have been uncovered.
* Finally, if the space is a mine itself, then all of the mines are uncovered,
  and the game is over.

The player wins, then, by managing to uncover all of the spaces that surround
mines without actually triggering those mines.

### Starting small

You'll want to make a directory on your computer and open that up in your code
editor of choice. Give it a meaningful name like `minesweeper`, and create two
files: `minesweeper.html` and `minesweeper.css`. We're going to be using this
project for the entire series. You should have the following file structure:

<ul class="file-tree">
  <li class="directory"><span>minesweeper/</span><ul>
      <li class="file">minesweeper.html</li>
      <li class="file">minesweeper.css</li>
    </ul>
  </li>
</ul>

The first thing we need to do is to display the board. There are multiple ways
to do this, but we don't want to have to write a bunch of CSS; tables will work
just fine. Open `minesweeper.html` and type:

``` html
<!DOCTYPE html>

<html>
  <head>
    <title>Minesweeper</title>
    <link rel="stylesheet" href="minesweeper.css">
    <script src="minesweeper.js"></script>
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

To make a board look like a board, we'll also want to add some minimal CSS.
We'll set the board to a reasonable size and add some visual feedback to each
cell when it's hovered over. Open `minesweeper.css` and type:

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

Great! Let's [take a look][minesweeper-1]{:target="_blank"} at what we have so
far:

[minesweeper-1]: /blog/minesweeper-1/minesweeper.html

<iframe height="300" width="100%" src="/blog/minesweeper-1/minesweeper.html" border="0"></iframe>

### What's next

Now we'll [use jQuery][minesweeper-2] to display the board instead of straight
HTML.

[minesweeper-2]: /blog/minesweeper-2/

<div class="nav-wrapper">
  <div class="nav nav--right">
    <a href="/blog/minesweeper-2/">Continue →</a>
  </div>
</div>
