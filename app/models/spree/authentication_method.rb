# frozen_string_literal: true

class Spree::AuthenticationMethod < ActiveRecord::Base
  validates :provider, :api_key, :api_secret, presence: true

  def self.active_authentication_methods?
    where(environment: ::Rails.env, active: true).exists?
  end

  scope :available_for, lambda { |user|
    sc = where(environment: ::Rails.env)
    sc = sc.where.not(provider: user.user_authentications.pluck(:provider)) if user && !user.user_authentications.empty?
    sc
  }

  def provider_name
    provider = SolidusSocial::OAUTH_PROVIDERS.find { |oauth_provider| oauth_provider[1] == self.provider }
    provider ? provider[0].capitalize : nil
  end

  def oauth_scope
    case provider
    when 'twitter2'
      'tweet.read users.read'
    else
      nil
    end
  end
end
