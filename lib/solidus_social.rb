# frozen_string_literal: true

require "solidus_core"
require "solidus_support"
require "solidus_auth_devise"

require "solidus_social/version"
require "solidus_social/engine"

module SolidusSocial
  def self.configured_providers
    ::Spree::SocialConfig.providers.keys.map(&:to_s)
  end

  def self.init_providers
    ::Spree::SocialConfig.providers.each do |provider, credentials|
      setup_key_for(provider, credentials[:api_key], credentials[:api_secret])
    end
  end

  def self.setup_key_for(provider, key, secret)
    Devise.setup do |config|
      config.omniauth provider, key, secret, setup: true
    end
  end
end
