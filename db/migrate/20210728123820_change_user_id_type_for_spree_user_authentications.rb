# frozen_string_literal: true

class ChangeUserIdTypeForSpreeUserAuthentications < SolidusSupport::Migration[4.2]
  def change
    change_column :spree_user_authentications, :user_id, :bigint
  end
end
