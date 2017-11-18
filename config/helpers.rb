require_relative "helpers/flickr_photo_helpers"
require_relative "helpers/haml_helpers"
require_relative "helpers/map_helpers"
require_relative "helpers/markdown_helpers"
require_relative "helpers/svg_helpers"
require_relative "helpers/title_helpers"
require_relative "helpers/youtube_video_helpers"

HelpersConfig = proc do
  helpers FlickrPhotoHelpers
  helpers HamlHelpers
  helpers MapHelpers
  helpers MarkdownHelpers
  helpers SvgHelpers
  helpers TitleHelpers
  helpers YoutubeVideoHelpers
end
