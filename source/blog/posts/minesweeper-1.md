---
title: Making Minesweeper in JavaScript, Part 1
teaser: >
  In the first post in this series, we introduce the project by making a simple
  board.
date: 2020-01-01
tags: programming
---

It's no secret that JavaScript is a very important part of the web. It's been
around for over 20 years, and as the Internet has expanded and evolved since
then, JavaScript has quietly gained some serious muscle to take on larger roles.
Time was that you'd only use the language to add gimmicks like falling
snowflakes to your pages; now you can use it to build apps that run on your
phone. Within the past 7 years alone, we've seen a major explosion of growth in
the JavaScript ecosystem as the language itself has received much-needed
modernizations and as power tools like Ember, Angular, and React have enabled
people to do more with less. There are almost a half a million JavaScript
modules that people have written and published to the larger community, and the
number is constantly growing.

Since JavaScript has been around for so long, if you are learning web
development or trying to brush on on your skills, there are resources left and
right at your fingertips. But amid the multitude of choice it can be hard to
find a foothold that will allow you to pull yourself along and gain real
progress. And while the JavaScript community is busy taking the language to new
heights, I feel that too often the fundamentals are left in the dust.

That's why, in this series, we're going to build something -- something that we
can finish in a reasonable amount of time but will demonstrate some of the key
basics in using JavaScript for modern web development -- and something that
gives us a platform we can to experiment with newer technologies.

![Microsoft Minesweeper][ms-minesweeper]
{:class="floating-image"}

What we'll be making is a game called Minesweeper. You may have heard of it --
until recently it was included on every Windows computer (along with Solitaire).
Even if you are unfamiliar with the game, it's a good choice because the rules
are simple and there are no animations, real-time play, or complicated logic.
With that in mind, here are the steps that we'll follow in this series:

[ms-minesweeper]: http://assets.mcmire.me/posts/2015-08-14-minesweeper-1/ms-minesweeper.png

* Using HTML and CSS to display the board
* Using [jQuery] to render the board dynamically
* Organizing code into functions
* Using the [JavaScript DOM API] in favor of jQuery
* Using objects instead of functions
* Re-implementing the game using React, Ember, and other tools

[jQuery]: http://jquery.com
[JavaScript DOM API]: https://www.w3.org/TR/html51/dom.html






That's why, whenever I learn a new
language, I always think of a project I can work on, something that's
interesting to me, something that's small enough to complete but large enough to
give me a sandbox in which I can play and discover new ideas.

Perhaps you're having trouble thinking of a project or you've tried to start one
but placed it on pause because it became too daunting. Allow me to offer a
suggestion -- why don't you write a game? There are many kinds of games, but 



But as the
landscape has changed, so too have people's opinions about how to write
JavaScript, and it means that unless you find the right resources, you could
easily be lost. 





different ways to make use of its 

As the web has grown, so too has the use of JavaScript. 
as people have discovered and re-discovered its potential as
well as its deficiencies. Lately 


JavaScript is everywhere. It's used across the web, and it's even used offline
as well. It's been around since the first browsers were created to access the
Internet over 20 years ago, and as the web has changed, how people use
JavaScript has changed, too. At first, websites were simple, and JavaScript was
used to add gimmicks such as falling snow or countdown clocks. But over time,
websites got more complicated and people started using the language to make

JavaScript is a very capable and versatile language; it is used everywhere on
the web. It is also as old as the modern web and has seen a lot of changes over
the years. It's seen a lot of explosive growth over the last several years as
new libraries have come and gone. Since JavaScript is so accessible there's a
wealth of information out there and if you are new to the scene or have not been
programming for a while you'll likely find a daunting variety of different tools
and techniques telling you to do it this way or that. It's also very
[misunderstood][javascript-misunderstood] -- and all these frameworks that exist
don't really help.

While that is fine I find
that at some point you have to learn the basics in order to get better, and I
don't feel that there aren't enough resources out there to do that. They may
teach you how to get started but then what happens after that? At some point you
have to fly.

[javascript-misunderstood]: http://www.crockford.com/javascript/javascript.html

One of the best ways I've found to level up your skills in any language is to
work on a small, inconsequential project that you iteratively improve as time
goes on. It helps a lot if the project is fun and bite size enough to where you
can make something functional in a short amount of time. What better way than to
build a game? We're not talking about a game that is complicated like Breakout
or Asteroids (although I might cover those in future blog posts). There will be
no talk of the game loop here. No, I wanted something that required interacting
with the DOM and were the rules of the game were slightly complex so that it
takes some effort to figure out. Finally, I wanted something that could be
iterated on.





. but if it's your first language or you
are still building experience in programming, you may be daunted by the array of
resources for writing code in JavaScript. There are many places you can go to
get started and there are many toolkits you can use that use the language under
the hood, but how do you get better? You have to actively seek out new
techniques and try them out.



If you owned a PC 15 years ago, you might remember Minesweeper. It's one of the
classic Windows games and was bundled along with other diversions such as
Solitaire, Pegged, Taipei, and the like.

In this post and the next several posts, we're going to be building Minesweeper
in JavaScript. We're going to start by writing very procedural code using
jQuery, proceed by removing jQuery and adding more abstraction, and close by
experimenting with ways we can implement Minesweeper using other frameworks and
languages.

### The game


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
