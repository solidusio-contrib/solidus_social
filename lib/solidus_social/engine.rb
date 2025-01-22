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

module SolidusSocial
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_social'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
