module MarkdownHelpers
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
end
