# frozen_string_literal: true

class Spree::AuthenticationMethod < ApplicationRecord
  belongs_to :store

  def self.provider_options
    SolidusSocial.configured_providers.map { |provider_name| [provider_name.split("_").first.camelize, provider_name] }
  end

  validates :provider, presence: true, uniqueness: { scope: :store }

  def self.active_authentication_methods?
    where(environment: ::Rails.env, active: true).exists?
  end

  scope :available_for, lambda { |user|
    sc = where(environment: ::Rails.env)
    sc = sc.where(['provider NOT IN (?)', user.user_authentications.map(&:provider)]) if user && !user.user_authentications.empty?
    sc
  }
end
