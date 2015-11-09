class mcmire.me.ForegroundCanvas
  constructor: ({ @element, width, height, clearBeforeRender }) ->
    @width = @element.width = width ? @element.offsetWidth
    @height = @element.height = height ? @element.offsetHeight
    @clearBeforeRender = clearBeforeRender ? true
    @ctx = @element.getContext("2d")

  drawCanvas: (canvas, scale) =>
    if @clearBeforeRender
      @ctx.clearRect(0, 0, @width, @height)

    @ctx.save()
    @ctx.scale(scale, scale)
    @ctx.imageSmoothingEnabled = false
    @ctx.mozImageSmoothingEnabled = false
    @ctx.drawImage(canvas.element, 0, 0)
    @ctx.restore()
