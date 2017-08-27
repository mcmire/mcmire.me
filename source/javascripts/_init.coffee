#= require ./_module
#= require ./_code_block
#= require ./_code_modal
#= require ./_grid
#= require ./_header
#= require ./_math_block
#= require ./_spoiler
#= require ./_illustration_registry
#= require ./_illustration_wrapper
#= require_tree ./illustrations/minesweeper-3

DEBUG_ANIMATION = false

renderGrid = ->
  grid = new mcmire.me.Grid(
    windowElement: window
    bodyElement: document.body
    contentElement: document.querySelector("[data-role='content']")
  )
  grid.activate()
  grid.render()

buildActivatedCodeModal = ->
  modalOverlay = document.querySelector("[data-role='modal-overlay']")
  modalWindow = document.querySelector("[data-role='modal-window']")

  if modalOverlay && modalWindow
    codeModal = new mcmire.me.CodeModal(
      bodyElement: document.body
      modalOverlay: modalOverlay
      modalWindow: modalWindow
    )
    codeModal.activate()
    codeModal

renderCodeBlocks = ->
  elements = document.querySelectorAll("pre")
  codeBlocks = _.map elements, (element) ->
    new mcmire.me.CodeBlock(
      bodyElement: document.body
      codeModal: mcmire.me.codeModal
      element: element
    )
  _.invokeMap codeBlocks, "render"

renderMathBlocks = ->
  elements = document.querySelectorAll("script[type='math/katex']")

  _.each elements, (element) ->
    mathBlock = new mcmire.me.MathBlock({ element })
    mathBlock.render()

initSpoilers = ->
  elements = document.querySelectorAll(".spoiler")

  _.each elements, (element) ->
    spoiler = new mcmire.me.Spoiler({ element })
    spoiler.activate()

initIllustrations = ->
  for element in document.querySelectorAll("[data-illustration]")
    illustrationName = element.getAttribute("data-illustration")
    illustrationConstructor =
      mcmire.me.illustrationRegistry.find(illustrationName)
    if illustrationConstructor
      illustrationWrapper = new mcmire.me.IllustrationWrapper({
        element,
        illustrationConstructor
      })
      illustrationWrapper.activate()
      illustrationWrapper.render()

mcmire.me.init = ->
  renderGrid()

  codeModal = buildActivatedCodeModal()

  if codeModal
    mcmire.me.codeModal = codeModal
    renderCodeBlocks()

  renderMathBlocks()
  initSpoilers()
  initIllustrations()
