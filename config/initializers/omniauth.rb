OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], {:scope => "user_location, user_tagged_places, email"}
end