BlogAreaConfig = proc do
  activate :blog do |blog|
    blog.name = "blog"
    blog.prefix = "blog"
    blog.sources = "posts/{title}.html"
    blog.permalink = "{title}"
    blog.layout = "blog_article"
    blog.default_extension = ".md"
    blog.publish_future_dated = (ENV.fetch("PUBLISH_DRAFTS", "false") == "true")

    page "blog/feed.xml", layout: false
  end
end
