if ENV["DEPLOYMENT_ENVIRONMENT"]
  Dotenv.overload(".env", ".env.#{ENV['DEPLOYMENT_ENVIRONMENT']}")
end
