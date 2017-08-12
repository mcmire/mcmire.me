class IllustrationRegistry
  constructor: ->
    @registry = {}

  register: (key, constructor) ->
    @registry[key] = constructor

  find: (key) =>
    @registry[key]

mcmire.me.illustrationRegistry = new IllustrationRegistry
