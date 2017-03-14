Deface::Override.new(virtual_path: 'spree/users/show',
                     name: 'add_socials_to_account_summary',
                     insert_after: '[data-hook="admin_settings_sub_tabs"]',
                     partial: 'spree/users/social',
                     disabled: false)
