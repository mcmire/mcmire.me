class mcmire.me.Spoiler
  constructor: ({ @element }) ->

  activate: =>
    @element.addEventListener("click", @_toggle)

  _toggle: =>
    @element.classList.toggle("revealed")
