S3SyncConfig = proc do
  activate :s3_sync do |s3_sync|
    s3_sync.bucket = ENV.fetch("S3_BUCKET")
    s3_sync.delete = false
    s3_sync.encryption = false
    s3_sync.index_document = "index.html"
    s3_sync.error_document = "404.html"
  end
end
