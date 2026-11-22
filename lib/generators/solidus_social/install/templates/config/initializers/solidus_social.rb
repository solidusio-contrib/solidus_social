# frozen_string_literal: true

Spree::SocialConfig.configure do |config|
  config.use_static_preferences!

  # Configure the Path prefix for OAuth paths
  # The default is /user/auth/:provider
  #
  # for /member/auth/:provider
  # config.path_prefix = 'member'
  # for /profile/auth/:provider
  # config.path_prefix = 'profile'
  # for /auth/:provider
  # config.path_prefix = ''

  config.providers = {
    facebook: {
      api_key: ENV["FACEBOOK_API_KEY"],
      api_secret: ENV["FACEBOOK_API_SECRET"]
    },
    github: {
      api_key: ENV["GITHUB_API_KEY"],
      api_secret: ENV["GITHUB_API_SECRET"]
    },
    google_oauth2: {
      api_key: ENV["GOOGLE_OAUTH2_API_KEY"],
      api_secret: ENV["GOOGLE_OAUTH2_API_SECRET"]
    },
    twitter2: {
      api_key: ENV["TWITTER_API_KEY"],
      api_secret: ENV["TWITTER_API_SECRET"]
    }
  }
end

SolidusSocial.init_providers

OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = "omniauth"

OmniAuth.config.on_failure = proc do |env|
  env["devise.mapping"] = Devise.mappings[Spree.user_class.table_name.singularize.to_sym]
  controller_klass = ActiveSupport::Inflector.constantize("Spree::OmniauthCallbacksController")
  controller_klass.action(:failure).call(env)
end
