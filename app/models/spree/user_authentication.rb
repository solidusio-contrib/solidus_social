# frozen_string_literal: true

class Spree::UserAuthentication < ActiveRecord::Base
  belongs_to :user
end
