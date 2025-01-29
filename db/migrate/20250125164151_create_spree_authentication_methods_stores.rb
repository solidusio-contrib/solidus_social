# frozen_string_literal: true

class CreateSpreeAuthenticationMethodsStores < SolidusSupport::Migration[4.2]
  def change
    create_table :spree_authentication_methods_stores, id: false do |t|
      t.belongs_to :authentication_method
      t.belongs_to :store
    end

    add_index :spree_authentication_methods_stores, [:authentication_method_id, :store_id], unique: true, name: 'authentication_method_id_store_id_unique_index'
  end
end
