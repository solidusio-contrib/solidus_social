# frozen_string_literal: true

class AddDbIndexToUserAuthentications < SolidusSupport::Migration[4.2]
  def change
    add_index :spree_user_authentications, [:uid, :provider], unique: true
    add_index :spree_user_authentications, :user_id
  end
end
