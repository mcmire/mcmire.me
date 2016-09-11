#= require ./_module
#= require ./_code_block
#= require ./_code_modal
#= require ./_grid
#= require ./_header
#= require ./_math_block
#= require ./_spoiler

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
  element = document.querySelector("[data-role='code-modal']")

  if element
    codeModal = new mcmire.me.CodeModal(
      bodyElement: document.body
      element: element
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
  _.invoke codeBlocks, "render"

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

mcmire.me.init = ->
  renderGrid()

  codeModal = buildActivatedCodeModal()

  if codeModal
    mcmire.me.codeModal = codeModal
    renderCodeBlocks()

  renderMathBlocks()
  initSpoilers()
