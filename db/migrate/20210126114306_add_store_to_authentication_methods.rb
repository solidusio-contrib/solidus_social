class AddStoreToAuthenticationMethods < ActiveRecord::Migration[6.1]
  def up
    change_table :spree_authentication_methods do |t|
      t.integer :store_id
      t.string  :site
    end

    add_index :spree_authentication_methods, :store_id
  end

  def down
    change_table :spree_authentication_methods do |t|
      t.remove :store_id
      t.string :site
    end
  end
end
