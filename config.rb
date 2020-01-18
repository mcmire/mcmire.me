require_relative "config/dotenv"

require_relative "config/blog_area"
require_relative "config/build"
require_relative "config/common"
require_relative "config/development"
require_relative "config/external_pipeline"
require_relative "config/helpers"
require_relative "config/kramdown"
require_relative "config/s3_sync"

instance_eval(&BlogAreaConfig)
instance_eval(&BuildConfig)
instance_eval(&CommonConfig)
instance_eval(&DevelopmentConfig)
instance_eval(&ExternalPipelineConfig)
instance_eval(&HelpersConfig)
instance_eval(&KramdownConfig)
instance_eval(&S3SyncConfig)
