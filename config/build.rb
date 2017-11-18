BuildConfig = proc do
  configure :build do
    # Enable cache buster (except for images)
    activate :asset_hash, ignore: [/\.jpg\Z/, /\.png\Z/]
  end
end
