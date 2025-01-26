# frozen_string_literal: true

class Spree::AuthenticationMethod < ActiveRecord::Base
  validates :provider, :api_key, :api_secret, presence: true

  has_many :store_authentication_methods, inverse_of: :authentication_method
  has_many :stores, through: :store_authentication_methods

  def self.active_authentication_methods?
    where(environment: ::Rails.env, active: true).exists?
  end

  scope :available_for, lambda { |user|
    sc = where(environment: ::Rails.env)
    sc = sc.where.not(provider: user.user_authentications.pluck(:provider)) if user && !user.user_authentications.empty?
    sc
  }

  scope :available_to_store, ->(store) do
    raise ArgumentError, "You must provide a store" if store.nil?

    store.authentication_methods.empty? ? all : where(id: store.authentication_method_ids)
  end

  def provider_name
    provider = SolidusSocial::OAUTH_PROVIDERS.find { |oauth_provider| oauth_provider.key == self.provider }
    provider ? provider.title.capitalize : nil
  end

  def oauth_scope
    case provider
    when 'twitter2'
      'tweet.read users.read'
    end
  end
end
