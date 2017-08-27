#= require scopedQuerySelectorShim/src/scopedQuerySelectorShim
#= require ./_module
#= require ./_transition_end_event_name

copyCodeBlock = (codeBlock) ->
  copyOfCodeBlock = codeBlock.cloneNode(true)
  everythingExceptCode = copyOfCodeBlock.querySelectorAll(":scope > :not(code)")
  _.invoke everythingExceptCode, "remove"
  copyOfCodeBlock

transitionEndEventName = mcmire.me.transitionEndEventName

class mcmire.me.CodeModal
  constructor: ({ @bodyElement, @modalOverlay, @modalWindow }) ->
    @closeButton = @modalWindow.querySelector("[data-role='modal-close']")
    @contentElement = @modalWindow.querySelector("[data-role='modal-content']")

  activate: =>
    @closeButton.addEventListener("click", @close)

  open: (codeBlock) =>
    copyOfCodeBlock = copyCodeBlock(codeBlock)
    copyOfCodeBlock.classList.add("expanded")

    @bodyElement.classList.add("code-modal-open")

    @modalOverlay.classList.remove("closed")
    @modalOverlay.classList.add("open")

    @modalWindow.classList.remove("closed")
    @modalWindow.classList.add("open")

    @contentElement.innerHTML = ""
    @contentElement.appendChild(copyOfCodeBlock)
    @contentElement.addEventListener("click", @_stopPropagation)

  close: (event) =>
    event.preventDefault()

    @bodyElement.classList.remove("code-modal-open")

    @modalOverlay.classList.remove("open")
    @modalOverlay.classList.add("closed")

    @modalWindow.classList.remove("open")
    @modalWindow.classList.add("closed")
    @modalWindow.addEventListener(transitionEndEventName, @_clear)

  _clear: =>
    @modalWindow.removeEventListener(transitionEndEventName, @_clear)
    @contentElement.innerHTML = ""
