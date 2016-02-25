xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = "http://mcmire.me/techblog"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link(
    "href" => URI.join(site_url, current_page.path),
    "rel" => "self",
    "type" => "application/atom+xml"
  )
  xml.title "Technobabble"

  if blog.articles.any?
    xml.updated(blog.articles.first.date.to_time.iso8601)
  end

  xml.author do
    xml.name "Elliot Winkler"
    xml.uri site_url
    xml.email "elliot.winkler@gmail.com"
  end

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.id URI.join(site_url, article.url)
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.title article.title, "type" => "html"
      xml.content article.body, "type" => "xhtml"
      xml.summary article.summary, "type" => "xhtml"
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
    end
  end
end
