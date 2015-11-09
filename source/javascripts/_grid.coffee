#= require ./_module

# http://beej.us/blog/2010/02/html5s-canvas-part-ii-pixel-manipulation/
setPixel = ({ imageData, position: { x, y }, color: { r, g, b, a } }) ->
  index = (x + y * imageData.width) * 4
  imageData.data[index + 0] = r
  imageData.data[index + 1] = g
  imageData.data[index + 2] = b
  imageData.data[index + 3] = a

pctToHex = (pct) ->
  return (pct * 256) - 1

removeUnit = (numberWithUnit) ->
  if numberWithUnit == "" || numberWithUnit == null
    0
  else
    numberWithUnit.toString().replace(/\w+$/, "")

addPx = (number) ->
  number + "px"

class mcmire.me.Grid
  G_KEY = 71
  K_KEY = 74
  J_KEY = 75
  SHIFT_OFFSETS = {}
  SHIFT_OFFSETS[K_KEY] = 1
  SHIFT_OFFSETS[J_KEY] = -1

  constructor: ({
    windowElement: @_windowElement
    bodyElement: @_bodyElement
    contentElement: @_contentElement
  }) ->
    @_load()

  activate: =>
    @_windowElement.addEventListener "keydown", @_respondToKeyDown

  render: =>
    contentStyle = @_contentElement.style

    if @_isVisible
      @_gridDataUrl ?= @_generate()
      contentStyle.backgroundImage = "url(" + @_gridDataUrl + ")"
      contentStyle.backgroundPositionX = addPx(@_backgroundPosition.x)
      contentStyle.backgroundPositionY = addPx(@_backgroundPosition.y)
    else
      contentStyle.backgroundImage = "none"

  _respondToKeyDown: (event) =>
    if event.shiftKey
      if event.keyCode == G_KEY
        @_toggle()
        @render()
      else if (event.keyCode == K_KEY || event.keyCode == J_KEY)
        @_shift(event)
        @render()

  _generate: =>
    width = 1
    bodyStyle = window.getComputedStyle(@_bodyElement)
    height = removeUnit(bodyStyle.lineHeight)

    canvas = document.createElement("canvas")
    canvas.width = width
    canvas.height = height
    ctx = canvas.getContext("2d")
    imageData = ctx.createImageData(width, height)

    setPixel(
      imageData: imageData
      position: { x: 0, y: height - 1 }
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.2) }
    )
    setPixel(
      imageData: imageData
      position: { x: 0, y: (height * 0.25) - 1 }
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.05) }
    )
    setPixel(
      imageData: imageData
      position: { x: 0, y: (height * 0.5) - 1 }
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.1) }
    )
    setPixel(
      imageData: imageData
      position: { x: 0, y: (height * 0.75) - 1 }
      color: { r: 255, g: 0, b: 0, a: pctToHex(0.05) }
    )
    ctx.putImageData(imageData, 0, 0)

    canvas.toDataURL("image/png")

  _shift: (event) =>
    @_backgroundPosition.y += SHIFT_OFFSETS[event.keyCode]
    @_save()

  _toggle: =>
    if @_isVisible
      @_hide()
    else
      @_show()

  _show: =>
    @_isVisible = true
    @_save()

  _hide: =>
    @_isVisible = false
    @_save()

  _load: =>
    rawData = localStorage.getItem("lic-grid")

    if rawData
      data = JSON.parse(rawData)
      @_isVisible = data.isVisible
      @_backgroundPosition = data.backgroundPosition
    else
      @_isVisible = false
      @_backgroundPosition = {
        x: removeUnit(@_contentElement.style.backgroundPositionX)
        y: removeUnit(@_contentElement.style.backgroundPositionY)
      }
      @_save()

  _save: =>
    data = JSON.stringify(
      isVisible: @_isVisible
      backgroundPosition: @_backgroundPosition
    )
    localStorage.setItem("lic-grid", data)
