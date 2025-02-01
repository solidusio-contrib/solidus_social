# frozen_string_literal: true

Spree::Backend::Config.configure do |config|
  settings_menu = config.menu_items.find { |item| item.label == :settings }

  if settings_menu
    settings_menu.children << config.class::MenuItem.new(
      label: :social_authentication_methods,
      url: :admin_authentication_methods_path,
      condition: -> { can?(:admin, Spree::AuthenticationMethod) }
    )
  end
end
