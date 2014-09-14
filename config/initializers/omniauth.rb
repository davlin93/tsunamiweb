OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 820271541324765, 'a7ea31e7f43e028ff634afa2ad7d6b7c'
end