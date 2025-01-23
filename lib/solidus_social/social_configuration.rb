# frozen_string_literal: true

module Spree
  class SocialConfiguration < Preferences::Configuration
    preference :path_prefix, :string, default: 'users'

    ::Spree::SocialConfig = Spree::SocialConfiguration.new
  end
end
