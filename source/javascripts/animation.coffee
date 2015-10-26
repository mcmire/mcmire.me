class mcmire.me.Animation
  SIXTY_FPS = 0.016  # seconds

  constructor: ({ @renderer }) ->
    @isPlaying = false
    @controls = []
    @lastRenderTime = null

  addControl: (control) =>
    @controls.push(control)

  activateControls: =>
    _.invoke(@controls, "activate")

  renderControls: =>
    _.invoke(@controls, "render")

  advance: (delta = SIXTY_FPS) =>
    @renderer.render(delta)

  pause: =>
    @isPlaying = false
    @renderControls()

  play: =>
    @isPlaying = true
    @renderControls()
    @_loop()

  _loop: =>
    if @isPlaying
      requestAnimationFrame =>
        @_time(@advance)
        @_loop()

  _time: (fn) =>
    if @lastRenderTime?
      delta = (new Date()).getTime() - @lastRenderTime
    else
      delta = 0

    fn(delta)

    @lastRenderTime = (new Date()).getTime()
