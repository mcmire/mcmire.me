class mcmire.me.IllustrationWrapper
  constructor: ({ @element, illustrationConstructor }) ->
    @width = parseInt(@element.dataset.width, 10)
    @height = parseInt(@element.dataset.height, 10)
    svgElement = @element.querySelector("svg")
    @illustration = new illustrationConstructor(element: svgElement)
    @overlayMade = false
    @isPlaying = false
    @hasBeenPlayed = false

  activate: =>
    @element.addEventListener "click", (event) =>
      event.preventDefault()
      if !@isPlaying
        @isPlaying = true
        @render()
        @illustration.play().then =>
          @isPlaying = false
          @hasBeenPlayed = true
          @render()

  render: =>
    if @width > 0
      @element.style.width = "#{@width}px"

    if @height > 0
      @element.style.height = "#{@height}px"

    if !@overlayMade
      { @overlay, @playButton, @replayButton } = @makeOverlay()
      @element.appendChild(@overlay)
      @overlayMade = true

    if @isPlaying
      @element.classList.add("is-playing")
      @overlay.classList.add("invisible")
    else
      @element.classList.remove("is-playing")
      @overlay.classList.remove("invisible")

    if @hasBeenPlayed
      @playButton.classList.add("hidden")
      @replayButton.classList.remove("hidden")
    else
      @playButton.classList.remove("hidden")
      @replayButton.classList.add("hidden")

  makeOverlay: =>
    overlay = document.createElement("div")
    overlay.classList.add("overlay")
    overlay.classList.add("invisible")

    playButton = document.createElement("button")
    playButton.classList.add("play")
    playButton.classList.add("hidden")
    overlay.appendChild(playButton)

    replayButton = document.createElement("button")
    replayButton.classList.add("replay")
    replayButton.classList.add("hidden")
    overlay.appendChild(replayButton)

    { overlay, playButton, replayButton }
