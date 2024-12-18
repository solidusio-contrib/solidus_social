# frozen_string_literal: true

module SolidusSocial
  module Spree
    module UserRegistrationsControllerDecorator
      def self.prepended(base)
        base.class_eval do
          after_action :clear_omniauth, only: :create
        end
      end

      private

      def build_resource(*args)
        super
        @spree_user.apply_omniauth(session[:omniauth]) if session[:omniauth]
        @spree_user
      end

      def clear_omniauth
        session[:omniauth] = nil unless @spree_user.new_record?
      end

      ::Spree::UserRegistrationsController.prepend self
    end
  end
end
