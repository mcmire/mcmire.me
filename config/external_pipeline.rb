ExternalPipelineConfig = proc do
  activate :external_pipeline,
    name: :webpack,
    command: build? ? "yarn run build" : "yarn run start",
    source: ".tmp/dist",
    latency: 1
end
