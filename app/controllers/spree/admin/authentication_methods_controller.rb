# frozen_string_literal: true

module Spree
  module Admin
    class AuthenticationMethodsController < ResourceController
      private

      def build_resource
        model_class.new(
          store_ids: [Spree::Store.default.id].compact
        )
      end
    end
  end
end
