# frozen_string_literal: true

require 'solidus_social/social_configuration'

module Spree
  def self.social_config
    @config ||= Spree::SocialConfiguration.new
  end

  def self.const_missing(name)
    name == :SocialConfig ? social_config : super
  end
end
