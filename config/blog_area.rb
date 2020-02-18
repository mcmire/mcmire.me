BlogAreaConfig = proc do
  # Sources:
  # * <https://github.com/middleman/middleman/issues/1902>
  # * <https://github.com/middleman/middleman/tree/master/middleman-core/fixtures/multiple-sources-app>
  files.watch(
    :source,
    path: File.expand_path(
      "../../../personal-content--blog/posts",
      __FILE__
    ),
    # This is where the resources will be placed in the sitemap —
    # this creates a sort of virtual path that we can refer to below
    destination_dir: "blog/posts",
    frontmatter: true,
    only: [/\.md(?:\.erb)?$/]
  )
  files.watch(
    :source,
    path: File.expand_path(
      "../../../personal-content--blog/assets",
      __FILE__
    ),
    destination_dir: "blog/assets",
    binary: true,
    only: [/\.(?:jpg|png|gif|svg|haml)$/]
  )
  files.watch(
    :source,
    path: File.expand_path(
      "../../../personal-content--blog/assets",
      __FILE__
    ),
    destination_dir: "blog/assets",
    only: [/\.(?:svg|haml)$/]
  )
  files.watch(
    :source,
    path: File.expand_path(
      "../../../personal-content--blog/demos",
      __FILE__
    ),
    destination_dir: "blog/demos",
    only: [/\.(?:html|js|css|scss|erb)$/]
  )

  activate :blog do |blog|
    blog.name = "blog"
    blog.prefix = "blog"
    # This is neither the URL path nor the real path — it's the virtual path
    blog.sources = "posts/{title}.html"
    blog.permalink = "{title}"
    blog.layout = "blog_article"
    blog.default_extension = ".md"
    blog.publish_future_dated = (ENV.fetch("PUBLISH_DRAFTS", "false") == "true")

    page "blog/feed.xml", layout: false
  end

  configure :build do
    ignore "blog/sample-post.html.md"
  end
end
