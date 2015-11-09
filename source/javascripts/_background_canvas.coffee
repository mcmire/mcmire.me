class mcmire.me.BackgroundCanvas
  @from: (foregroundCanvas, args) ->
    scale = args.scale ? 1
    clearBeforeRender = args.clearBeforeRender
    element = document.createElement("canvas")
    width = Math.floor(foregroundCanvas.width / scale)
    height = Math.floor(foregroundCanvas.height / scale)
    new mcmire.me.BackgroundCanvas({
      element,
      width,
      height,
      clearBeforeRender
    })

  constructor: ({ @element, width, height, clearBeforeRender }) ->
    @width = @element.width = width
    @height = @element.height = height
    @clearBeforeRender = clearBeforeRender ? true
    @ctx = @element.getContext("2d")
    @imageData = @ctx.createImageData(@width, @height)

  render: =>
    @ctx.clearRect(0, 0, @width, @height)
    @ctx.putImageData(@imageData, 0, 0)

    if @clearBeforeRender
      @imageData = @ctx.createImageData(@width, @height)

  drawPixels: ({ points, color }) =>
    _.each points, (point) =>
      @drawPixel(point, color)

  # Source: <http://beej.us/blog/data/html5s-canvas-2-pixel/>
  drawPixel: (point, color) =>
    index = (point.x + (point.y * @width)) * 4

    if color.alpha == 0
      @imageData.data[index + 0] = 0
      @imageData.data[index + 1] = 0
      @imageData.data[index + 2] = 0
      @imageData.data[index + 3] = 0
    else
      @imageData.data[index + 0] = color.red
      @imageData.data[index + 1] = color.green
      @imageData.data[index + 2] = color.blue
      @imageData.data[index + 3] = color.alpha * 255
