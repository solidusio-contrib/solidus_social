# frozen_string_literal: true

require 'omniauth-facebook'
require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'omniauth/twitter2'
require 'omniauth/rails_csrf_protection'
require 'deface'
require 'spree/core'
require 'solidus_social/config'
require 'solidus_social/facebook_omniauth_strategy_ext'
require 'solidus_social/solidus_support'

module SolidusSocial
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_social'

    initializer 'solidus_social.environment', before: 'spree.environment' do
      AUTHENTICATION_METHOD_PATH = config.root.join(
        "app/models/spree/authentication_method.rb"
      ).to_s

      load AUTHENTICATION_METHOD_PATH
    end

    initializer 'solidus_social.initialize_providers' do
      SolidusSocial.initialize_oauth_providers
    end

    USER_DECORATOR_PATH = root.join(
      "app/decorators/models/solidus_social/spree/user_decorator.rb"
    ).to_s

    initializer 'solidus_social.decorate_spree_user' do |app|
      next unless app.respond_to?(:reloader)

      app.reloader.after_class_unload do
        # Reload and decorate the spree user class immediately after it is
        # unloaded so that it is available to devise when loading routes
        load USER_DECORATOR_PATH
      end
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
