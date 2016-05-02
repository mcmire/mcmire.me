#= require ./_module
#= require ./_advance_frame_button
#= require ./_animation
#= require ./_code_block
#= require ./_code_modal
#= require ./_grid
#= require ./_header
#= require ./_header_background
#= require ./_math_block
#= require ./_pause_button
#= require ./_play_button
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

initHeaderRenderer = ->
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

initAnimation = ->
  renderer = initHeaderRenderer()
  animation = new mcmire.me.Animation(
    renderer: renderer
    fps: 10
  )

  if DEBUG_ANIMATION
    animation.addControl(initAdvanceFrameButton(animation))
    animation.addControl(initPauseButton(animation))
    animation.addControl(initPlayButton(animation))
    animation.activateControls()
    animation.renderControls()

  animation.advance()

  animation

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
  mcmire.me.codeModal = buildActivatedCodeModal()
  renderCodeBlocks()
  initAnimation()
  renderMathBlocks()
  initSpoilers()
