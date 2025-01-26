# frozen_string_literal: true

module SolidusSocial
  module Spree
    module StoreDecorator
      def self.prepended(base)
        base.class_eval do
          has_many :store_authentication_methods, class_name: 'Spree::StoreAuthenticationMethod'
          has_many :authentication_methods, through: :store_authentication_methods, class_name: 'Spree::AuthenticationMethod'
        end
      end

      ::Spree::Store.prepend self
    end
  end
end
