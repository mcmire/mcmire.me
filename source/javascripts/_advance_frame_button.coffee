class mcmire.me.AdvanceFrameButton
  constructor: ({ @animation, @element }) ->

  render: =>

  activate: =>
    @element.addEventListener("click", @animation.advance)
