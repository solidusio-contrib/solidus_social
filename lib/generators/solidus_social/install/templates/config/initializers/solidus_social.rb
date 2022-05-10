# frozen_string_literal: true

Rails.application.config.to_prepare do
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
        api_key: ENV['FACEBOOK_API_KEY'],
        api_secret: ENV['FACEBOOK_API_SECRET'],
      },
      twitter: {
        api_key: ENV['TWITTER_API_KEY'],
        api_secret: ENV['TWITTER_API_SECRET'],
      },
      github: {
        api_key: ENV['GITHUB_API_KEY'],
        api_secret: ENV['GITHUB_API_SECRET'],
      },
      google_oauth2: {
        api_key: ENV['GOOGLE_OAUTH2_API_KEY'],
        api_secret: ENV['GOOGLE_OAUTH2_API_SECRET'],
      },
      amazon: {
        api_key: ENV['AMAZON_API_KEY'],
        api_secret: ENV['AMAZON_API_SECRET'],
      }
    }
  end

  SolidusSocial.init_providers

  OmniAuth.config.logger = Logger.new(STDOUT)
  OmniAuth.logger.progname = 'omniauth'

  OmniAuth.config.on_failure = proc do |env|
    env['devise.mapping'] = Devise.mappings[Spree.user_class.table_name.singularize.to_sym]
    controller_name = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
    controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
    controller_klass.action(:failure).call(env)
  end
end
