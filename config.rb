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

blog_names = ["blog", "travelogue-2016"]
blog_titles = {
  "blog" => "Technobabble",
  "travelogue-2016" => "Elliot's 2016 Travelogue"
}

blog_names.each do |blog_name|
  activate :blog do |blog|
    blog.name = blog_name
    blog.prefix = blog_name
    blog.sources = "{year}/{month}/{title}.html"
    blog.permalink = "{title}"
    blog.layout = "#{blog_name}-article"
    blog.default_extension = ".md"

    page "#{blog_name}/feed.xml", layout: false
  end
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

  def render_markdown(content)
    tempfile = Tempfile.open("markdown")
    tempfile.write(content)
    tempfile.close

    Tilt["md"].new(tempfile).render
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
