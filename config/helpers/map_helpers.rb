module MapHelpers
  def embed_map(url)
    <<-HTML
<iframe
  width="100%"
  height="400"
  scrolling="no"
  frameborder="0"
  id="player"
  src="#{url}"
  allowfullscreen="true">
</iframe>
    HTML
  end
end
