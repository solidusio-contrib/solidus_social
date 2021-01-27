# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'
require 'solidus_auth_devise'

require 'solidus_social/version'
require 'solidus_social/engine'

module SolidusSocial
  def self.configured_providers
    ::Spree::SocialConfig.providers.keys.map(&:to_s)
  end
end

