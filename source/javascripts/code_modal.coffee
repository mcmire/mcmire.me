#= require ./module
#= require ./transition_end_event_name

copyCodeBlock = (codeBlock) ->
  copyOfCodeBlock = codeBlock.cloneNode(true)
  everythingExceptCode = copyOfCodeBlock.querySelectorAll(":scope > :not(code)")
  _.invoke everythingExceptCode, "remove"
  copyOfCodeBlock

transitionEndEventName = mcmire.me.transitionEndEventName

class mcmire.me.CodeModal
  constructor: ({ @bodyElement, @element }) ->
    @closeButton = @element.querySelector("[data-role='modal-close']")
    @contentElement = @element.querySelector("[data-role='modal-content']")

  activate: =>
    @closeButton.addEventListener("click", @close)

  open: (codeBlock) =>
    copyOfCodeBlock = copyCodeBlock(codeBlock)

    @contentElement.innerHTML = ""
    @contentElement.appendChild(copyOfCodeBlock)

    @bodyElement.classList.add("code-modal-open")
    @element.classList.remove("closed")
    @element.classList.add("open")

    @contentElement.addEventListener("click", @_stopPropagation)
    @element.addEventListener("click", @close)

  close: (event) =>
    event.preventDefault()

    @element.addEventListener(transitionEndEventName, @_clear)

    @bodyElement.classList.remove("code-modal-open")
    @element.classList.remove("open")
    @element.classList.add("closed")

    @contentElement.removeEventListener("click", @_stopPropagation)
    @element.removeEventListener("click", @close)

  _clear: =>
    @contentElement.innerHTML = ""
    @element.removeEventListener(transitionEndEventName, @_clear)

  _stopPropagation: (event) =>
    event.stopPropagation()
