#= require ./_pixel_canvas_renderer

class mcmire.me.HeaderBackground
  randomAlpha = -> (Math.random() * 0.2)

  PROPERTIES_TO_DELEGATE = [
    "drawPixel"
    "unscaledHeight"
    "unscaledWidth"
  ]

  constructor: ({ @renderer }) ->
    _.each PROPERTIES_TO_DELEGATE, (property) =>
      @[property] = @renderer[property]

  draw: (delta) =>
    _.each [0..@unscaledHeight-1], (y) =>
      _.each [0..@unscaledWidth-1], (x) =>
        point = { x, y }
        color = { red: 0, blue: 0, green: 0, alpha: randomAlpha() }
        @drawPixel(point, color)
