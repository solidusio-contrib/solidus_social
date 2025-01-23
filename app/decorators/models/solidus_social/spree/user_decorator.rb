# frozen_string_literal: true

module SolidusSocial
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.class_eval do
          has_many :user_authentications, dependent: :destroy

          devise :omniauthable
        end
      end

      def apply_omniauth(omniauth)
        skip_signup_providers = SolidusSocial::OAUTH_PROVIDERS.select { |provider| provider.skip_signup }.map(&:key)
        if skip_signup_providers.include?(omniauth['provider']) && email.blank?
          self.email = omniauth['info']['email']
        end
        user_authentications.build(provider: omniauth['provider'], uid: omniauth['uid'])
      end

      def password_required?
        (user_authentications.empty? || password.present?) && super
      end

      ::Spree.user_class.prepend self
    end
  end
end
