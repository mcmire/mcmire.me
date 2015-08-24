#= require ./module
#= require ./grid

mcmire.me.init = ->
  grid = new mcmire.me.Grid(
    windowElement: window
    bodyElement: document.body
    contentElement: document.querySelector("[data-role='content']")
  )
  grid.activate()
  grid.render()
