class RemoveAuthenticationMethods < SolidusSupport::Migration[4.2]
  def change
    drop_table :spree_authentication_methods
  end
end
