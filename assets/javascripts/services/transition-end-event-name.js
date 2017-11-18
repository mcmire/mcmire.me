// Adapted from David Walsh: http://davidwalsh.name/css-animation-callback

import { find } from "lodash";

const possibleEventNames = {
  transition: "transitionend",
  OTransition: "oTransitionEnd",
  MozTransition: "transitionend",
  WebkitTransition: "webkitTransitionEnd"
};

const dummyElement = document.createElement("dummy-element");

const transitionEndEventName = find(possibleEventNames, eventName => {
  return dummyElement.style[eventName] != null;
});

export default transitionEndEventName;
