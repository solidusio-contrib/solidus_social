# frozen_string_literal: true

Deface::Override.new(
  virtual_path: "spree/admin/shared/_settings_sub_menu",
  name: "add_social_providers_link_configuration_menu",
  insert_bottom: '[data-hook="admin_settings_sub_tabs"]',
  disabled: false,
) do
  <<~HTML
    <% if can? :admin, Spree::AuthenticationMethod %>
      <%= tab :authentication_methods, url: spree.admin_authentication_methods_path %>
    <% end %>
  HTML
end
