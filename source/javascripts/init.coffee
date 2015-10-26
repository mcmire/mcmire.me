#= require ./module
#= require ./code_block
#= require ./code_modal
#= require ./fonts
#= require ./grid

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

mcmire.me.init = ->
  renderGrid()
  mcmire.me.codeModal = buildActivatedCodeModal()
  renderCodeBlocks()
  mcmire.me.fonts.render()
