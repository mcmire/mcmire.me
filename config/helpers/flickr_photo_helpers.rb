module FlickrPhotoHelpers
  def extract_flickr_photo_id_from(url)
    regex = %r{\Ahttps://farm\d+\.staticflickr.com/\d+/([0-9]+)_[a-z0-9]+.jpg\Z}
    match = url.match(regex)

    if match
      match.captures.first
    else
      raise "Couldn't extract Flickr photo id from: #{url}"
    end
  end

  def embed_flickr_photo(static_url, orientation:, description:, width: 375, height: 500)
    photo_id = extract_flickr_photo_id_from(static_url)

    if orientation == :landscape
      width, height = height, width
    end

    <<-HTML
<figure class="image photo #{orientation}">
  <a
    data-flickr-embed="true"
    href="https://www.flickr.com/photos/mcmire/#{photo_id}"
    title="#{description}"
    target="_blank">
    <img
      src="#{static_url}"
      alt="#{description}">
  </a>
  <figcaption>#{description}</figcaption>
</figure>
    HTML
  end
end
