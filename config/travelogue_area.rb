TravelogueAreaConfig = proc do
  activate :blog do |blog|
    blog.name = "travelogue-2016"
    blog.prefix = "travelogue-2016"
    blog.sources = "posts/{category}/{year}-{month}-{day}.html"
    blog.permalink = "{title}"
    blog.layout = "travelogue_2016_article"
    blog.default_extension = ".md"

    page "travelogue-2016/feed.xml", layout: false
  end
end
