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
        skip_signup_providers = SolidusSocial::OAUTH_PROVIDERS.map { |p| p[1] if p[2] == 'true' }.compact
        if skip_signup_providers.include? omniauth['provider']
          self.email = omniauth['info']['email'] if email.blank?
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
