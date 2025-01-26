# frozen_string_literal: true

module Spree
  module Admin
    module AuthenticationMethodsHelper
      def available_authentication_methods(current_store, spree_current_user)
        Spree::AuthenticationMethod
          .available_to_store(current_store)
          .available_for(spree_current_user)
      end

      def available_stores
        @available_stores ||= Spree::Store.accessible_by(current_ability)
      end
    end
  end
end
