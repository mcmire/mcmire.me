# Adapted from David Walsh: http://davidwalsh.name/css-animation-callback

possibleEventNames =
  transition: "transitionend"
  OTransition: "oTransitionEnd"
  MozTransition: "transitionend"
  WebkitTransition: "webkitTransitionEnd"

dummyElement = document.createElement("dummy-element")

mcmire.me.transitionEndEventName = _.find possibleEventNames, (eventName) ->
  dummyElement.style[eventName]?
