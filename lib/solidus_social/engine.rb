# frozen_string_literal: true

require 'omniauth-twitter'
require 'omniauth-facebook'
require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'omniauth-amazon'
require 'deface'
require 'coffee_script'
require 'spree/core'
require 'solidus_social/facebook_omniauth_strategy_ext'

module SolidusSocial
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_social'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    USER_DECORATOR_PATH = root.join(
      "app/decorators/models/solidus_social/spree/user_decorator.rb"
    ).to_s

    initializer 'solidus_social.environment', before: 'spree.environment' do
      Rails.application.config.to_prepare do
        ::Spree::SocialConfig = ::Spree::SocialConfiguration.new
      end
    end

    initializer 'solidus_social.decorate_spree_user' do |app|
      next unless app.respond_to?(:reloader)

      app.reloader.after_class_unload do
        # Reload and decorate the spree user class immediately after it is
        # unloaded so that it is available to devise when loading routes
        load USER_DECORATOR_PATH
      end
    end
  end
end
