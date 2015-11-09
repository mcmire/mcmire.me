class mcmire.me.Header
  constructor: ({ @element, @animation }) ->

  activate: =>
    @element.addEventListener "mouseover", =>
      @animation.play()

    @element.addEventListener "mouseout", =>
      console.log "pause"
      @animation.pause()

