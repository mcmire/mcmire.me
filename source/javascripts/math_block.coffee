#= require ./katex.min.js

class mcmire.me.MathBlock
  constructor: ({ @element }) ->

  render: =>
    newWrapper = document.createElement("div")
    newWrapper.classList.add("math")
    katex.render(@element.textContent, newWrapper)
    @element.parentNode.insertBefore(newWrapper, @element)
    @element.parentNode.removeChild(@element)
