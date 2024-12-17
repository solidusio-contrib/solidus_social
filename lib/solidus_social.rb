# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'
require 'solidus_auth_devise'

require 'solidus_social/version'
require 'solidus_social/engine'


module SolidusSocial
  OAUTH_PROVIDERS = [
    %w(Facebook facebook true),
    %w(Twitter twitter2 false),
    %w(Github github false),
    %w(Google google_oauth2 true)
  ]

  # Setup all OAuth providers
  def self.init_provider(provider)
    begin
      ActiveRecord::Base.connection_pool.with_connection(&:active?)
    rescue
      return
    end

    return unless ActiveRecord::Base.connection.data_source_exists?('spree_authentication_methods')
    key, secret = nil
    ::Spree::AuthenticationMethod.where(environment: ::Rails.env).each do |auth_method|
      next unless auth_method.provider == provider
      key = auth_method.api_key
      secret = auth_method.api_secret
      Rails.logger.info("[Solidus Social] Loading #{auth_method.provider.capitalize} as authentication source")
    end
    setup_key_for(provider.to_sym, key, secret)
  end

  def self.setup_key_for(provider, key, secret)
    Devise.setup do |config|
      config.omniauth provider, key, secret, setup: true, info_fields: 'email, name'
    end
  end
end
