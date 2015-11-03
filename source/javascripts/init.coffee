#= require ./module
#= require ./advance_frame_button
#= require ./animation
#= require ./code_block
#= require ./code_modal
#= require ./fonts
#= require ./grid
#= require ./header_background
#= require ./math_block
#= require ./pause_button
#= require ./play_button

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

initRenderer = ->
  element = document.querySelector("[data-role='header-background']")
  renderer = new mcmire.me.PixelCanvasRenderer(
    element: element
    scale: 4
    clearBeforeRender: false
  )
  background = new mcmire.me.HeaderBackground({ renderer })
  renderer.addObject(background)
  renderer

initAdvanceFrameButton = (animation) ->
  element = document.querySelector("[data-role='advance-frame-button']")
  new mcmire.me.AdvanceFrameButton({ animation, element })

initPauseButton = (animation) ->
  element = document.querySelector("[data-role='pause-button']")
  new mcmire.me.PauseButton({ animation, element })

initPlayButton = (animation) ->
  element = document.querySelector("[data-role='play-button']")
  new mcmire.me.PlayButton({ animation, element })

initHeaderBackground = ->
  renderer = initRenderer()
  animation = new mcmire.me.Animation({ renderer })

  if DEBUG_ANIMATION
    animation.addControl(initAdvanceFrameButton(animation))
    animation.addControl(initPauseButton(animation))
    animation.addControl(initPlayButton(animation))
    animation.activateControls()
    animation.renderControls()

  animation.advance()

renderMathBlocks = ->
  elements = document.querySelectorAll("script[type='math/katex']")

  _.each elements, (element) ->
    mathBlock = new mcmire.me.MathBlock({ element })
    mathBlock.render()

mcmire.me.init = ->
  renderGrid()
  mcmire.me.codeModal = buildActivatedCodeModal()
  renderCodeBlocks()
  initHeaderBackground()
  mcmire.me.fonts.render()
  renderMathBlocks()
