#= require ./_module

class mcmire.me.CodeBlock
  constructor: ({ @codeModal, @element }) ->
    @horizontalOverflowIndicatorElement =
      @_createHorizontalOverflowIndicatorElement()
    @verticalOverflowIndicatorElement =
      @_createVerticalOverflowIndicatorElement()
    @overlayElement = @_createOverlayElement()
    @viewInFullButtonElement = @_createViewInFullButtonElement()

  render: =>
    if @_doesOverflow()
      @element.classList.add("overflows")
      @element.appendChild(@overlayElement)
      @element.appendChild(@viewInFullButtonElement)
      @overlayElement.addEventListener "click", @_expand
      @viewInFullButtonElement.addEventListener "click", @_expand

      if @_doesOverflowHorizontally()
        @element.appendChild(@horizontalOverflowIndicatorElement)

      if @_doesOverflowVertically()
        @element.appendChild(@verticalOverflowIndicatorElement)

  _expand: =>
    @codeModal.open(@element)

  _collapse: =>
    @codeModal.close()

  _createHorizontalOverflowIndicatorElement: =>
    element = document.createElement("div")
    element.classList.add("horizontal-overflow-indicator")
    element

  _createVerticalOverflowIndicatorElement: =>
    element = document.createElement("div")
    element.classList.add("vertical-overflow-indicator")
    element

  _createOverlayElement: =>
    element = document.createElement("div")
    element.classList.add("overlay")
    element

  _createViewInFullButtonElement: ->
    element = document.createElement("div")
    element.classList.add("view-in-full")
    element.innerHTML = "View in full"
    element

  _doesOverflow: =>
    @_doesOverflowHorizontally() || @_doesOverflowVertically()

  _doesOverflowHorizontally: =>
    @element.scrollWidth > @element.clientWidth

  _doesOverflowVertically: =>
    @element.scrollHeight > @element.clientHeight
