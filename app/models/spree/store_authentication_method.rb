module Spree
  class StoreAuthenticationMethod < ActiveRecord::Base
    self.table_name = 'spree_authentication_methods_stores'

    belongs_to :store, class_name: 'Spree::Store', touch: true
    belongs_to :authentication_method, class_name: 'Spree::AuthenticationMethod', touch: true

    validates :store, :authentication_method, presence: true
    validates :store_id, uniqueness: { scope: :authentication_method_id }
  end
end
