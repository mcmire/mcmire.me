require_relative "config/sprockets_bower_fonts_integration"

activate :dotenv, env: ".env.local"

SprocketsBowerFontsIntegration.new(self).configure

sprockets.import_asset "katex/dist/katex.min.css"

# Make it so that any HTML files inside of subdirectories that hold files for a
# blog post are not considered as "blog sources"
Middleman::Blog::BlogTemplateProcessor.class_eval do
  def self.match(name)
    case name
      when 'year' then '\d{4}'
      when 'month' then '\d{2}'
      when 'day' then '\d{2}'
      else '[^/]*'
    end
  end
end

require_relative "kramdown_katex_engine"
Kramdown::Converter.add_math_engine(:katex, KramdownKatexEngine)

blog_titles = {
  "blog" => "Technobabble",
  "travelogue-2016" => "Elliot's 2016 Travelogue"
}

activate :blog do |blog|
  blog.name = "blog"
  blog.prefix = "blog"
  blog.sources = "{year}/{month}/{title}.html"
  blog.permalink = "{title}"
  blog.layout = "blog-article"
  blog.default_extension = ".md"

  page "blog/feed.xml", layout: false
end

activate :blog do |blog|
  blog.name = "travelogue-2016"
  blog.prefix = "travelogue-2016"
  blog.sources = "posts/{category}/{year}-{month}-{day}.html"
  blog.permalink = "{title}"
  blog.layout = "travelogue-2016-article"
  blog.default_extension = ".md"

  page "travelogue-2016/feed.xml", layout: false
end

helpers do
  define_method :page_title do
    pieces = []

    if current_article
      pieces << current_article.title
    elsif current_page.data.title
      pieces << current_page.data.title
    end

    pieces << blog_titles[blog.options.name]

    pieces.join(" ∙ ")
  end

  def render_markdown(content, paragraph: true)
    tempfile = Tempfile.open("markdown")
    tempfile.write(content)
    tempfile.close

    html = Tilt["md"].new(tempfile).render

    if !paragraph
      html.sub!("<p>", "").sub("</p>", "")
    end

    html
  end

  def embed_yt_video(video_id, width: 560, height: 315, description: nil)
    <<-HTML
<figure class="embed">
  <iframe
    width="#{width}"
    height="#{height}"
    src="https://www.youtube.com/embed/#{video_id}"
    frameborder="0"
    allowfullscreen>
  </iframe>
  <figcaption>#{description}</figcaption>
</figure>
    HTML
  end

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
<figure class="image">
  <a
    data-flickr-embed="true"
    href="https://www.flickr.com/photos/mcmire/#{photo_id}"
    title="#{description}"
    target="_blank">
    <img
      src="#{static_url}"
      width="#{width}"
      height="#{height}"
      alt="#{description}">
  </a>
  <figcaption>#{description}</figcaption>
</figure>
    HTML
  end

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

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :directory_indexes

set :markdown_engine, :kramdown
set :markdown, input: "GFM", enable_coderay: false, hard_wrap: false,
  math_engine: "katex"

activate :s3_sync do |s3_sync|
  s3_sync.bucket = ENV.fetch("S3_BUCKET")
  s3_sync.delete = false
  s3_sync.encryption = false
end

configure :development do
  set :debug_assets, true
end

configure :build do
  set :debug_assets, false

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
