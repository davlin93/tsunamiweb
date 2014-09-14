OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 356821657808253, '5b7eb29f703e13d1eaf6a3e10172fbf1'
end