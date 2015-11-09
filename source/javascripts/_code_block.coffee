#= require ./_module

class mcmire.me.CodeBlock
  constructor: ({ @codeModal, @element }) ->
    @borderElement = @_createBorderElement()
    @overlayElement = @_createOverlayElement()
    @viewInFullButtonElement = @_createViewInFullButtonElement()

  render: =>
    if @_doesOverflow()
      @element.classList.add("overflows")
      @element.appendChild(@borderElement)
      @element.appendChild(@overlayElement)
      @element.appendChild(@viewInFullButtonElement)
      @overlayElement.addEventListener "click", @_expand
      @viewInFullButtonElement.addEventListener "click", @_expand

  _expand: =>
    @codeModal.open(@element)

  _collapse: =>
    @codeModal.close()

  _createBorderElement: =>
    element = document.createElement("div")
    element.classList.add("border")
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
    @element.scrollHeight > @element.clientHeight
