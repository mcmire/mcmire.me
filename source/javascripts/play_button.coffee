class mcmire.me.PlayButton
  constructor: ({ @animation, @element }) ->

  activate: =>
    @element.addEventListener("click", @animation.play)

  render: =>
    if @animation.isPlaying
      @element.classList.add("hide")
    else
      @element.classList.remove("hide")
