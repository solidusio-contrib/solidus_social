Deface::Override.new(virtual_path: 'spree/admin/shared/_settings_sub_menu',
                     name: 'add_social_providers_link_configuration_menu',
                     insert_bottom: '[data-hook="admin_settings_sub_tabs"]',
                     text: '<%= configurations_sidebar_menu_item Spree.t(:social_authentication_methods), spree.admin_authentication_methods_path %>',
                     disabled: false)
