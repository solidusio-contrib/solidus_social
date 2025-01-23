# frozen_string_literal: true

class SeedAuthenticationMethodsWithEnvVariables < SolidusSupport::Migration[4.2]
  PROVIDER_CREDENTIALS = {
    facebook: {
      api_key: ENV['FACEBOOK_API_KEY'],
      api_secret: ENV['FACEBOOK_API_SECRET']
    },
    github: {
      api_key: ENV['GITHUB_API_KEY'],
      api_secret: ENV['GITHUB_API_SECRET']
    },
    google_oauth2: {
      api_key: ENV['GOOGLE_OAUTH2_API_KEY'],
      api_secret: ENV['GOOGLE_OAUTH2_API_SECRET']
    },
    twitter2: {
      api_key: ENV['TWITTER_API_KEY'],
      api_secret: ENV['TWITTER_API_SECRET']
    }
  }.freeze

  def up
    PROVIDER_CREDENTIALS.each do |provider, credentials|
      find_or_create_authentication_method(provider, credentials) if valid_credentials?(credentials)
    end
  end

  def down
    PROVIDER_CREDENTIALS.each do |provider, credentials|
      delete_authentication_method(provider, credentials) if valid_credentials?(credentials)
    end
  end

  private

  def valid_credentials?(credentials)
    credentials[:api_key].present? && credentials[:api_secret].present?
  end

  def find_or_create_authentication_method(provider, credentials)
    Spree::AuthenticationMethod.find_or_create_by!(
      environment: Rails.env,
      provider: provider.to_s
    ) do |auth_method|
      auth_method.api_key = credentials[:api_key]
      auth_method.api_secret = credentials[:api_secret]
      auth_method.active = true
    end
  end

  def delete_authentication_method(provider, credentials)
    Spree::AuthenticationMethod.where(
      environment: Rails.env,
      provider: provider.to_s,
      api_key: credentials[:api_key],
      api_secret: credentials[:api_secret]
    ).destroy_all
  end
end
