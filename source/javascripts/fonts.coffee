class Fonts
  ENABLED = true
  MAX_LOADING_DURATION = 5000
  LOAD_CHECKER_INTERVAL = 300
  LOADING_CLASS = "wf-loading"

  constructor: ->
    @loadCheckerTimer = null
    @startedCheckingIfFontsLoaded = null

  render: (fn = ->) =>
    @_whenLoadedOrFailed = fn

    if ENABLED
      @_importTypekit()
    else
      @_fail()

  _importTypekit: =>
    document.body.appendChild(@_createTypekitScriptElement())

  _createTypekitScriptElement: =>
    script = document.createElement("script")
    script.src = "//use.typekit.net/ryx5vex.js"
    script.async = true
    script.onload = script.onreadystatechange = @_load(script)
    script.onerror = @_fail
    script

  _reset: =>
    @loadCheckerTimer = setTimeout(
      @_checkLoadedOrFail,
      LOAD_CHECKER_INTERVAL
    )

  _load: (script) =>
    =>
      if !script.readyState || ["complete", "loaded"] in script.readyState
        @startedCheckingIfLoaded = @_now()
        Typekit.load({ async: true })
        @_reset()

  _fail: =>
    document.documentElement.classList.remove(LOADING_CLASS)
    clearTimeout(@loadCheckerTimer) if @loadCheckerTimer
    @_whenLoadedOrFailed()

  _checkLoadedOrFail: =>
    if @_isLoaded()
      @_whenLoadedOrFailed()
    else if @_timedOutLoading()
      @_fail()
    else
      @_reset()

  _isLoaded: ->
    !document.documentElement.classList.contains(LOADING_CLASS)

  _timedOutLoading: =>
    (@_now() - @startedCheckingIfLoaded) > MAX_LOADING_DURATION

  _now: ->
    (new Date()).getTime()

mcmire.me.fonts = new Fonts
