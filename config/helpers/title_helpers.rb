module TitleHelpers
  def page_title(default: nil)
    pieces = []

    if current_article
      pieces << current_article.title
    elsif current_page.data.title
      pieces << current_page.data.title
    elsif default
      pieces << default
    end

    pieces << "Elliot Winkler"

    pieces.join(" ∙ ")
  end
end
