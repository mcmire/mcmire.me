class mcmire.me.PauseButton
  constructor: ({ @animation, @element }) ->

  activate: =>
    @element.addEventListener("click", @animation.pause)

  render: =>
    if @animation.isPlaying
      @element.classList.remove("hide")
    else
      @element.classList.add("hide")
