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

activate :blog do |blog|
  blog.sources = "blog/{year}/{month}/{day}/{title}.html"
  blog.layout = "article_layout"
  blog.default_extension = ".md"

  page "feed.xml", layout: false
  page "sample-post.html", layout: :article_layout
end

helpers do
  def page_title
    pieces = []

    if current_article
      pieces << current_article.title
    elsif current_page.data.title
      pieces << current_page.data.title
    end

    pieces << "Technobabble"

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

configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
