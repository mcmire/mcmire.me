module YoutubeVideoHelpers
  def embed_yt_video(video_id, width: 560, height: 315, description: nil)
    <<-HTML
<figure class="embed video">
  <iframe
    src="https://www.youtube.com/embed/#{video_id}"
    frameborder="0"
    allowfullscreen>
  </iframe>
  <figcaption>#{description}</figcaption>
</figure>
    HTML
  end
end
