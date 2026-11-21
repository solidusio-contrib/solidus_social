# frozen_string_literal: true

module Spree
  module Admin
    class AuthenticationMethodsController < ResourceController
      private

      def permitted_resource_params
        params.require(:authentication_method).permit(:environment, :provider, :active)
      end
    end
  end
end
