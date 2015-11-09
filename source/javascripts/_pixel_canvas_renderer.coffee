#= require ./_foreground_canvas
#= require ./_background_canvas

class mcmire.me.PixelCanvasRenderer
  constructor: ({ element, @scale, clearBeforeRender }) ->
    @foregroundCanvas = new mcmire.me.ForegroundCanvas({ element })
    @backgroundCanvas = new mcmire.me.BackgroundCanvas.from(
      @foregroundCanvas,
      { @scale, clearBeforeRender }
    )
    @objects = []
    @unscaledWidth = @backgroundCanvas.width
    @unscaledHeight = @backgroundCanvas.height
    @scaledWidth = @foregroundCanvas.width
    @scaledHeight = @foregroundCanvas.height
    { @drawPixels, @drawPixel } = @backgroundCanvas

  addObject: (object) =>
    @objects.push(object)

  render: (delta) =>
    _.each @objects, (object) -> object.draw(delta)
    @backgroundCanvas.render()
    @foregroundCanvas.drawCanvas(@backgroundCanvas, @scale)

  normalizeX: (x) ->
    (x + @unscaledWidth) % @unscaledWidth

  normalizeY: (y) ->
    (y + @unscaledHeight) % @unscaledHeight
