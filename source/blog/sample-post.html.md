---
blog: blog
title: Making Minesweeper in JavaScript, Part 1 and This Is Just a Really Long Title and Such and I'll Just Keep Going
date: 2015-08-14
layout: blog_article
---

Lorem ipsum dolor sit amet, <i>consectetur adipiscing elit</i>. Integer vel mi
lectus. Maecenas scelerisque lectus vitae nisl elementum porttitor.

Mauris convallis <code>Post::LoremIpsum</code> lorem quis vulputate interdum.
<a href="#">Proin in metus sed nunc sagittis</a> interdum eu ut nibh. Aliquam
et viverra quam. In consequat justo dictum, commodo sapien eget, dapibus
felis. Etiam posuere neque sed tempus feugiat. Fusce leo nibh,
<code>PostImporter#abracadabra</code> luctus sed congue sed, volutpat sodales
purus.

Proin dignissim erat id felis gravida, nec blandit eros gravida. Nullam
tincidunt dolor quis mauris auctor, a porta tellus laoreet. Praesent et ultrices
ex. Phasellus risus urna, lacinia et nisi vitae, molestie faucibus elit.

Mauris porttitor rhoncus vestibulum. Suspendisse potenti. Fusce lectus velit,
maximus non est sit amet, elementum porta felis. Suspendisse potenti. Aliquam
eget ultricies dui, ut pretium felis. Aenean fermentum faucibus sapien eu
suscipit. In eget orci rutrum, scelerisque justo non, efficitur metus.

1. In mi quam, rutrum non facilisis nec, blandit sit amet massa.
   Vestibulum vel ultricies mauris. Nam eu nibh nulla. Praesent accumsan
   pulvinar quam at eleifend. Proin lobortis ornare orci sed elementum. Vivamus
   hendrerit lectus et rhoncus venenatis.
1. Duis ex nunc, viverra nec tincidunt vel, rutrum sit amet est.
1. Nam eu nibh nulla.

Etiam ornare est lacus, sit amet faucibus orci maximus vitae. Praesent varius
est eget odio varius, ut fermentum velit finibus. Nulla aliquam mi ac magna
consectetur hendrerit at ut nulla. Nunc maximus porttitor lobortis.

Duis at augue felis. Phasellus et elit at felis venenatis sollicitudin nec eget
enim. Donec pharetra sit amet leo sit amet rhoncus. Quisque ut imperdiet est.
Nulla ut risus leo.

|------------------+------------------------|
| This is a header | This is another header |
|------------------+------------------------|
| First | Second | Third |

### This is a Subheader

Fusce volutpat, <span class="hilite">mauris sed iaculis consectetur</span>, eros
elit viverra leo, iaculis tincidunt mauris felis tristique nisl. Proin semper
scelerisque libero. Ut porttitor finibus metus, <a href="#">eu elementum lorem
sodales eu</a>. Pellentesque consectetur pulvinar arcu, dapibus iaculis enim
aliquam quis. Nam et mollis sem This is a footnote. Morbi vitae posuere sapien,
sit amet ullamcorper libero.

``` coffeescript
grade = (student, period=(if b? then 7 else 6), messages={"A": "Excellent"}) ->
  if student.excellentWork
    "A+"
  else if student.okayStuff
    if student.triedHard then "B" else "B-"
  else
    "C"

square = (x) -> x * x

two = -> 2

math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x

race = (winner, runners...) ->
  print winner, runners

class Animal extends Being
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."

hi = `function() {
  return [document.title, "Hello JavaScript"].join(": ");
}`

heredoc = """
CoffeeScript subst test #{ 010 + 0xf / 0b10 + "nested string #{ /\n/ }"}
"""

###
CoffeeScript Compiler v1.2.0
Released under the MIT License
###

OPERATOR = /// ^ (
?: [-=]>             # function
) ///
```

#### This is a Sub-Subheader

Maecenas vel sagittis mauris. Proin hendrerit lectus id nibh tincidunt
vulputate. In mi quam, rutrum non facilisis nec, blandit sit amet massa.
Vestibulum vel ultricies mauris. Nam eu nibh nulla. Praesent accumsan pulvinar
quam at eleifend. Proin lobortis ornare orci sed elementum. Vivamus hendrerit
lectus et rhoncus venenatis. Phasellus aliquet augue quis hendrerit consequat.

``` clojure
(def ^:dynamic chunk-size 17)

(defn next-chunk [rdr]
  (let [buf (char-array chunk-size)
        s (.read rdr buf)]
  (when (pos? s)
    (java.nio.CharBuffer/wrap buf 0 s))))

(defn chunk-seq [rdr]
  (when-let [chunk (next-chunk rdr)]
    (cons chunk (lazy-seq (chunk-seq rdr)))))
```

Etiam ornare est lacus, sit amet faucibus orci maximus vitae. Praesent varius
est eget odio varius, ut fermentum velit finibus. Nulla aliquam mi ac magna
consectetur hendrerit at ut nulla. Nunc maximus porttitor lobortis.

Duis at augue felis. Phasellus et elit at felis venenatis sollicitudin nec eget
enim. Donec pharetra sit amet leo sit amet rhoncus. Quisque ut imperdiet est.
Nulla ut risus leo.

#### This is Another Sub-Subheader

Phasellus id elit ex. Sed cursus sit amet mauris maximus hendrerit. Nunc semper
ante eget nibh interdum pulvinar. Ut pretium felis vel ultrices accumsan. Aenean
ante quam, dapibus non ornare sed, consequat vitae mi. Quisque iaculis congue
quam eget lobortis. Ut et est eu massa commodo auctor at nec odio. Nulla
facilisi. Integer quis massa augue.

$$
f(x) = \int_{-\infty}^\infty
    \hat f(\xi)\,e^{2 \pi i \xi x}
    \,d\xi
$$

Proin dignissim erat id felis gravida, nec blandit eros gravida. Nullam
tincidunt dolor quis mauris auctor, a porta tellus laoreet. Praesent et ultrices
ex. Phasellus risus urna, lacinia et nisi vitae, molestie faucibus elit.

Mauris porttitor rhoncus vestibulum. Suspendisse potenti. Fusce lectus velit,
maximus non est sit amet, elementum porta felis. Suspendisse potenti. Aliquam
eget ultricies dui, ut pretium felis. Aenean fermentum faucibus sapien eu
suscipit. In eget orci rutrum, scelerisque justo non, efficitur metus.

* Fusce ut libero tortor. Nam lacinia facilisis nibh, eu imperdiet diam
  malesuada sed.
* Donec ultricies risus at magna vestibulum, pellentesque faucibus mauris
  pretium.
* Cras sed metus condimentum, tempus turpis eu, euismod risus.

Donec at enim id nulla porttitor lobortis eu vitae arcu. Sed tempor leo lacus,
et mollis mi placerat vitae.

### This is Another Subheader

Aenean at hendrerit leo, id egestas leo. Etiam non sodales enim, a rutrum odio.
Vivamus gravida posuere dui, a lobortis risus gravida ut. Mauris varius pretium
magna, eget tincidunt erat ornare ultrices.

``` ruby
module Features
  module Matchers
    def have_row(expected_row)
      HaveRowMatcher.new(self, expected_row)
    end

    class HaveRowMatcher
      def initialize(context, expected_row)
        @context = context
        @expected_row = expected_row
      end

      def description
        "should have row containing #{expected_row}"
      end

      def matches?(element)
        @element = element
        table = Table.new(context, element)
        @actual_rows =
          if expected_row.is_a?(Hash)
            table.to_array_of_hashes
          else
            table.to_array_of_arrays
          end

        @actual_rows.include?(expected_row)
      end
    end
  end
end
```

Sed lacinia ante dignissim, ultrices metus ut, lobortis quam. Vestibulum
lobortis nisi lectus, ut efficitur risus pretium vel. Pellentesque dictum dui et
aliquet vehicula.

* Maecenas faucibus ante.
* Non neque venenatis consequat.
* Duis ex nunc, viverra nec tincidunt vel, rutrum sit amet est.

### Colors!

<div class="swatches">
  <div class="swatch blue-swatch">blue</div>
  <div class="swatch dark-gray-swatch">dark gray</div>
  <div class="swatch light-gray-swatch">light gray</div>
</div>
