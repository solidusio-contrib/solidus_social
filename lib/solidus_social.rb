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
    %w(Github github true),
    %w(Google google_oauth2 true)
  ]

  def self.initialize_oauth_providers
    begin
      ActiveRecord::Base.connection_pool.with_connection do
        if ActiveRecord::Base.connection.data_source_exists?('spree_authentication_methods')
          OAUTH_PROVIDERS.each do |provider|
            init_provider(provider[1])
          end
        else
          Rails.logger.warn("[Solidus Social] Database table 'spree_authentication_methods' does not exist.")
        end
      end
    rescue ActiveRecord::NoDatabaseError => e
      Rails.logger.error("[Solidus Social] Database not found: #{e.message}")
    rescue => e
      Rails.logger.error("[Solidus Social] An error occurred while initializing providers: #{e.message}")
    end
  end

  def self.init_provider(provider)
    key, scope, secret = nil
    ::Spree::AuthenticationMethod.where(environment: ::Rails.env).each do |auth_method|
      next unless auth_method.provider == provider
      key    = auth_method.api_key
      secret = auth_method.api_secret
      scope  = auth_method.oauth_scope
      Rails.logger.info("[Solidus Social] Loading #{auth_method.provider.capitalize} as authentication source")
    end
    setup_key_for(provider.to_sym, key, secret, scope)
  end

  def self.setup_key_for(provider, key, secret, scope)
    Devise.setup do |config|
      config.omniauth provider, key, secret, scope: scope, setup: true, info_fields: 'email, name'
    end
  end
end
