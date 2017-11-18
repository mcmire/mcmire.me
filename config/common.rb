CommonConfig = proc do
  set :css_dir, "assets/stylesheets"
  set :js_dir, "assets/javascripts"
  set :images_dir, "assets/images"
  set :fonts_dir, "assets/fonts"

  activate :directory_indexes

  page "404.html", directory_index: false
  page "*.svg", layout: false
end
