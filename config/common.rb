CommonConfig = proc do
  set :css_dir, "assets/stylesheets"
  set :js_dir, "assets/javascripts"
  set :images_dir, "assets/images"
  # Make it so that we can require shared-settings.scss from our content repos
  # without having to know exactly where it is
  # Source: <https://github.com/middleman/middleman/blob/master/middleman-core/fixtures/sass-assets-path-app/config.rb>
  set :sass_assets_paths, [File.join(root, "assets", "stylesheets")]
  # Set this so that when linking to another page, resource.url includes
  # index.html, which is how resources are stored in the sitemap under their
  # destination_path
  # set :strip_index_file, false

  activate :directory_indexes
  # FIXME: do this?
  activate :relative_assets

  page "404.html", directory_index: false
  # FIXME as it's descending into other directories
  page "*.svg", layout: false
end
