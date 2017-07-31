Prism.languages.prompt =
  prompt:
    pattern: /^(> ).+/m
    inside:
      command:
        pattern: /(> ).+/
        lookbehind: true
      command_leader:
        pattern: />/
  response:
    pattern: /^(< ).+/m
    inside:
      response_leader:
        pattern: /</

Prism.hooks.add "wrap", (env) ->
  if env.type is "command_leader"
    env.content = "❯"
  else if env.type is "response_leader"
    env.content = "❮"
