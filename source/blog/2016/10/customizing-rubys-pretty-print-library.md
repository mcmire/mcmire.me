---
title: Customizing Ruby's PrettyPrint library
teaser: "..."
date: 2016-10-01
tags: ruby
---

Right now I am writing a [Ruby library][super_diff] that lets you compare two
data structures. For instance, one way you could use it is by feeding it two
hashes. You might find out, then, that there were certain keys present in one
hash that weren't present in another, or you might find that there were two
values that were almost the same except for some key differences. The library is
intended to work recursively, and it is designed to compare not only hashes, but
also arrays, strings, and perhaps other kinds of objects as well. Finally, it's
also designed to plug into RSpec, so that if you're testing equality between two
complex data structures, you can get meaningful output to determine how those
two values differ.

There are two challenges to solve in order to write this library. First, how
do we compare hashes and arrays? This is a large problem, one which I may leave
for a future blog post -- so let's not worry about that right now. An easier and
more immediate problem that we face is: How do we present the results to the end
user?

### Displaying diffs

Let's say, for instance, that you, the user, want to compare a number and a
string. These two values are obviously nowhere near the same, but the library
needs to indicate this somehow. Here's the output it might produce:

<div class="code shell">
  <div>
    irb&gt; SuperDiff.diff(1, "foo")
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      1
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      "foo"
    </span>
  </div>
</div>

Now let's say you want to compare a number and an array. You might get this
instead:

<div class="code shell">
  <div>
    irb&gt; SuperDiff.diff(1, ["foo", "bar"])
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      1
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      [
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;"foo",
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;"bar"
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      ]
    </span>
  </div>
</div>

Notice how in this case, the library would split up the given array into
multiple lines for readability. The same thing could happen for a hash as well:

<div class="code shell">
  <div>
    irb&gt; SuperDiff.diff(1, { "foo" => "bar", "fiz" => "buz" })
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      1
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      {
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;"foo" => "bar",
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;"fiz" => "buz"
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      }
    </span>
  </div>
</div>

Formatting data structures like this -- broken up across multiple lines -- is
called *pretty printing*. How do we accomplish this? Well, Ruby actually has
some pretty-printing functionality built into its standard library. Let's take a
look at how it works.

### A quick primer on pretty-printing objects

The easiest way to pretty print an object is by using the `pp` method:

```
irb> require "pp"
irb> array = Array.new(12) { "foo" }
irb> pp array
["foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo"]
```

`pp` will print out its results to standard out. If we don't want that, but want
a string back instead, we can use the `pretty_inspect` method that's available
on all objects:

```
irb> require "pp"
irb> array = Array.new(12) { "foo" }
irb> array.pretty_inspect
=> "[\"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\"]\n"
```

Both of these methods are shortcuts for using `PP.pp`:

```
irb> require "pp"
irb> array = Array.new(12) { "foo" }
irb> PP.pp(array, "")
=> "[\"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\",\n \"foo\"]\n"
irb> puts PP.pp(array, "")
["foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo",
 "foo"]
```

### The problem with pretty-printing

`pp` and friends are good, but we can't quite make of use of them to format
diffs. Why is that?

Let's say we're comparing two hashes. Here's what we would want to see:

<div class="code shell">
  <div>
    irb&gt; SuperDiff.diff(<br>
    irb&gt;   { "foo" => "FOO", "bar" => "BAR" },<br>
    irb&gt;   { "baz" => "BAZ", "qux" => "QUX" }<br>
    irb&gt; )
  </div>
  <div>
    <span class="line-unchanged">
      {
    </span>
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      &nbsp;&nbsp;"foo" => "FOO",
    </span>
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      &nbsp;&nbsp;"bar" => "BAR"
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;"baz" => "BAZ",
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;"qux" => "QUX"
    </span>
  </div>
  <div>
    <span class="line-unchanged">
      }
    </span>
  </div>
</div>

But if we used `pp`, then we would see something like this:

<div class="code shell">
  <div>
    irb&gt; SuperDiff.diff(<br>
    irb&gt;   { "foo" => "FOO", "bar" => "BAR" },<br>
    irb&gt;   { "baz" => "BAZ", "qux" => "QUX" }<br>
    irb&gt; )
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      &nbsp;&nbsp;{ "foo" => "FOO",
    </span>
  </div>
  <div>
    <span class="line-with-deletions">
      <span class="indicator">-</span>
      &nbsp;&nbsp;&nbsp; "bar" => "BAR" }
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;{ "baz" => "BAZ",
    </span>
  </div>
  <div>
    <span class="line-with-additions">
      <span class="indicator">+</span>
      &nbsp;&nbsp;&nbsp; "qux" => "QUX" }
    </span>
  </div>
</div>

This isn't quite right. Ideally, the opening and closing braces should be on
their own lines; they shouldn't be considered as part of the changes. Otherwise,
the diff could be confusing to read, especially for more complex data
structures.

So we need a custom pretty-printer. We wouldn't want to create one from stratch
though -- that would be a little silly, and it would take a lot of work. We just
need one that formats objects like the default pretty-printer, but with some
small differences. Is there a way to re-use some of the code that's in the
standard library?

As it turns out, yes. In addition to `pp` and PP, the standard library provides
a PrettyPrint class. This class does most of the heavy lifting in the
pretty-printing process; in fact, the PP class inherits from PrettyPrint to
bring in all of its functionality and even add some of its own. So in theory, we
could introduce a class of our own that inherits from PP, and that would let us
override the code that formats objects so that our curly braces and square
brackets end up on their own line.

Great! Now that we have a plan of attack, let's crack open PrettyPrint and take
a look at what's inside.

### A walkthrough of PrettyPrint

Between the two of them, PrettyPrint and PP provide a DSL that is used to
manually build the final formatted representation for a particular object.

The terminology used within the DSL, and to some extend the algorithm that
PrettyPrint uses, are derived from ["Strictly Pretty"] by Christian Lindig,
which was in turn derived from two papers, ["The Design of a Pretty-Printing
Library"] by John Hughes and ["A Prettier Printer"] by Philip Wadler. (Notably,
Hughes' paper has been used to implement pretty-printing in [Haskell], and
Wadler's has been used for [OCaml], [Elixir], [Lua], and [Chicken Scheme], among
others, I'm sure.) You can read these papers if you like -- they don't take long
-- but since we are concerning ourselves with a custom implementation of an
algorithm, it wouldn't do us much good to talk about the algorithm itself.
Instead, we can learn all we need by observing how PrettyPrint works in practice
and by reading the code.

For instance, one thing to know is that an object may be represented on a single
line:

```
irb> pp ["foo", "bar"]
["foo", "bar"]
```

But if the object is large enough -- specifically, if the inspected version of
that object spans more than 79 characters -- then it will be represented across
multiple lines:

```
irb> pp ["foo", "bar", "baz", "qux", "blargh", "fiz", "buz", "zing", "zang", "floogh", "blargh"]
["foo",
 "bar",
 "baz",
 "qux",
 "blargh",
 "fiz",
 "buz",
 "zing",
 "zang",
 "floogh",
 "blargh"]
```

To help with understanding the behavior of PrettyPrint, I'd like to introduce
three concepts that are central to the PrettyPrint class. This is going to be a
little abstract -- we'll talk these terms later -- so bear with me for now:

  * **Text.** I'll define this as a string of any characters. This string could
    represent a value like `1` or `"foo"`, curly brackets, square brackets, a
    comma, or something else entirely.
  * **Breakable.** I'll define this as malleable whitespace that joins text
    together. The documentation calls these "line break hints".
  * **Group**. I'll define this as a collection of "texts" and "breakables". I
    called breakables "malleable whitespace" and "line break hints" above.
    Here's why: all of the breakables in a group start out being represented by
    spaces, but may switch over to new lines en masse if the character length of
    the entire group exceeds 79 characters.

We have everything we need now to start diving into the PrettyPrint code:

* `PrettyPrint.new`
* `#text`
* `#breakable`
* `#group`
* `#object_group`
* `#object_address_group`
* `#comma_breakable`
* `#seplist`
* `#pp`
* `PP.pp`
* `#pretty_inspect`

[Haskell]: https://hackage.haskell.org/package/pretty
["Strictly Pretty"]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.34.2200
["The Design of a Pretty-Printing Library"]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.38.8777
["A Prettier Printer"]: http://homepages.inf.ed.ac.uk/wadler/topics/language-design.html#prettier
[Chicken Scheme]: http://wiki.call-cc.org/eggref/4/strictly-pretty
[Elixir]: https://github.com/elixir-lang/elixir/commit/b335b1663d18cdef2d2487b0aaa60fef405b92d6
[OCaml]: https://ocaml.janestreet.com/ocaml-core/112.17/doc/core_extended.112.17.00/_build/lib/pp/
[Lua]: https://github.com/zoon/luapp/
[this version of PrettyPrint]: https://github.com/ruby/ruby/blob/68ebbbfebe5b666cf76ab41f1e6191a172d62690/lib/prettyprint.rb

#### Initializer

Let's get some context by taking a look at the initializer:

``` ruby
def initialize(output=''.dup, maxwidth=79, newline="\n", &genspace)
  @output = output
  @maxwidth = maxwidth
  @newline = newline
  @genspace = genspace || lambda {|n| ' ' * n}

  @output_width = 0
  @buffer_width = 0
  @buffer = []

  root_group = Group.new(0)
  @group_stack = [root_group]
  @group_queue = GroupQueue.new(root_group)
  @indent = 0
end
```

Although we don't know much about these instance variables, we can make some
reasonable assumptions. There's an `@output` string; we will be building this as
we go along, and judging by the name, this will get returned at the end. There's
`@maxwidth`; this will control at which point groups will spill over into
multiple lines (at least, according to the documentation above this method).
`@buffer`, `@group_stack`, and `@group_queue`, by their very names, will be
filled and reset as we go along. Finally, `@indent`, since it starts out at 0,
must represent the current indentation level, which will be raised and lowered
throughout the process. 

#### text

``` ruby
def text(obj, width=obj.length)
  if @buffer.empty?
    @output << obj
    @output_width += width
  else
    text = @buffer.last
    unless Text === text
      text = Text.new
      @buffer << text
    end
    text.add(obj, width)
    @buffer_width += width
    break_outmost_groups
  end
end
```

Glancing through the codebase, we can see that `text` is the most basic of those
in the PrettyPrint interface. There are two behaviors depending on whether there
is something in the buffer or not.

If there is nothing in the buffer, which would happen on the first runthrough,
then we add the given `obj` (which must be a string, otherwise we wouldn't be
able to compute a length for it) straight to the output, and we update
`@output_width` with its width. (It's worth it to note that `@output_width` must
be getting reset at some point later, otherwise it wouldn't be very useful!)

If there is something in the buffer, we wrap the string in a Text object and add
it to the buffer along with its width, updating `@buffer_width` at the same
time. We also call `break_outmost_groups`; we'll come back to this method later.

#### breakable

``` ruby
def breakable(sep=' ', width=sep.length)
  group = @group_stack.last
  if group.break?
    flush
    @output << @newline
    @output << @genspace.call(@indent)
    @output_width = @indent
    @buffer_width = 0
  else
    @buffer << Breakable.new(sep, width, self)
    @buffer_width += width
    break_outmost_groups
  end
end
```

#### group

``` ruby
def group(indent=0, open_obj='', close_obj='', open_width=open_obj.length, close_width=close_obj.length)
  text open_obj, open_width
  group_sub {
    nest(indent) {
      yield
    }
  }
  text close_obj, close_width
end

def group_sub
  group = Group.new(@group_stack.last.depth + 1)
  @group_stack.push group
  @group_queue.enq group
  begin
    yield
  ensure
    @group_stack.pop
    if group.breakables.empty?
      @group_queue.delete group
    end
  end
end
```

We'll go a bit out of order and jump to `group` next. You already know that it's
a container of "texts" and "breakables", so let's see what the code does
specifically.

The `group` method takes five arguments: `indent`, a measure of how far over the
group should appear in the output when it is printed; `open_obj` and
`close_obj`, two strings that will be used to demarcate the beginning and end of
this group; and `open_width` and `close_width`, the widths of these strings
(which can apparently be customized, although I'm not sure why that would
happen).

At the beginning and end of the method, we use `text` to add `open_obj` and
`close_obj` to the final output. But the part in between is what we're really
after, and there we call out to two methods, `group_sub` and `nest`, to do the
bulk of the work.

`group_sub` does four things. First, it creates a new Group object to represent
the group. This is initialized with one more than the depth of the previously
created group; if no groups have been created yet, then the new depth will be 1
(since, if you take a look back, `@group_stack` was initialized with a single
Group of 0 depth in the initializer). After this, we go through a typical "do
something, yield block, undo the thing" routine, but with a twist. The new Group
is added both to the group stack and queue, the given block is yielded, and the
group is removed from the stack -- but after this, whether it is removed from
the queue depends on whether the group contains breakables. There's no way to
know the significance of this at this stage; we must presume that the queue will
be processed in some meaningful way later.

#### breakable

Now that we know about `text` and `group`, we can take a look at `breakable`:

``` ruby
def breakable(sep=' ', width=sep.length)
  group = @group_stack.last
  if group.break?
    flush
    @output << @newline
    @output << @genspace.call(@indent)
    @output_width = @indent
    @buffer_width = 0
  else
    @buffer << Breakable.new(sep, width, self)
    @buffer_width += width
    break_outmost_groups
  end
end
```



[super_diff]: https://github.com/mcmire/super_diff
