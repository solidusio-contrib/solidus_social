# frozen_string_literal: true

RSpec.describe 'Signing in using Omniauth', :js do
  context 'facebook' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'facebook',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.mock_auth[:facebook] = {
        'provider' => 'facebook',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'email' => 'mockuser@example.com',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end

    it 'going to sign in' do
      visit spree.login_path
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
      click_link 'Logout'
      click_link 'Login'
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
    end

    # Regression test for #91
    it "attempting to view 'My Account' works" do
      visit spree.login_path
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
      click_link 'My Account'
      expect(page).to have_text 'My Account'
    end

    it "view 'My Account'" do
      visit spree.login_path
      click_on 'Login with facebook'
      expect(page).to have_text 'You are now signed in with your facebook account.'
      click_link 'My Account'
      expect(page).not_to have_selector 'div#social-signin-links'
    end
  end

  context 'github' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'github',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.mock_auth[:github] = {
        'provider' => 'github',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'email' => 'mockuser@example.com',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end

    it 'going to sign in' do
      visit spree.login_path
      click_on 'Login with github'
      expect(page).to have_text 'You are now signed in with your github account.'
      click_link 'Logout'
      click_link 'Login'
      click_on 'Login with github'
      expect(page).to have_text 'You are now signed in with your github account.'
    end

    # Regression test for #91
    it "attempting to view 'My Account' works" do
      visit spree.login_path
      click_on 'Login with github'
      expect(page).to have_text 'You are now signed in with your github account.'
      click_link 'My Account'
      expect(page).to have_text 'My Account'
    end

    it "view 'My Account'" do
      visit spree.login_path
      click_on 'Login with github'
      expect(page).to have_text 'You are now signed in with your github account.'
      click_link 'My Account'
      expect(page).not_to have_selector 'div#social-signin-links'
    end
  end

  context 'google_oauth2' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'google_oauth2',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.mock_auth[:google_oauth2] = {
        'provider' => 'google_oauth2',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'email' => 'mockuser@example.com',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end

    it 'going to sign in' do
      visit spree.login_path
      click_on 'Login with google_oauth2'
      expect(page).to have_text 'You are now signed in with your google_oauth2 account.'
      click_link 'Logout'
      click_link 'Login'
      click_on 'Login with google_oauth2'
      expect(page).to have_text 'You are now signed in with your google_oauth2 account.'
    end

    # Regression test for #91
    it "attempting to view 'My Account' works" do
      visit spree.login_path
      click_on 'Login with google_oauth2'
      expect(page).to have_text 'You are now signed in with your google_oauth2 account.'
      click_link 'My Account'
      expect(page).to have_text 'My Account'
    end

    it "view 'My Account'" do
      visit spree.login_path
      click_on 'Login with google_oauth2'
      expect(page).to have_text 'You are now signed in with your google_oauth2 account.'
      click_link 'My Account'
      expect(page).not_to have_selector 'div#social-signin-links'
    end
  end

  context 'twitter' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'twitter2',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter2] = {
        'provider' => 'twitter2',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }
    end

    it 'going to sign in' do
      visit spree.login_path
      click_on 'Login with twitter'
      expect(page).to have_text 'Please confirm your email address to continue'.upcase
      fill_in 'Email', with: 'user@example.com'
      click_button 'Create'
      expect(page).to have_text 'Welcome! You have signed up successfully.'
    end
  end

  context 'Merge guest user cart with authenticated one' do
    before do
      Spree::AuthenticationMethod.create!(
        provider: 'google_oauth2',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
      OmniAuth.config.mock_auth[:google_oauth2] = {
        'provider' => 'google_oauth2',
        'uid' => '123545',
        'info' => {
          'name' => 'mockuser',
          'email' => 'mockuser@example.com',
          'image' => 'mock_user_thumbnail_url'
        },
        'credentials' => {
          'token' => 'mock_token',
          'secret' => 'mock_secret'
        }
      }

      # Create a default store
      Spree::Store.create!(
        name: 'Default Store',
        code: 'default',
        url: 'www.example.com',
        mail_from_address: 'store@example.com',
        default_currency: 'USD',
        default: true
      )

      # Create a product
      @product = create(:product)
    end

    it 'merges guest and user orders after login' do
      # Step 1: Login and create an order with quantity 1
      visit spree.login_path
      click_on 'Login with google_oauth2'
      expect(page).to have_text 'You are now signed in with your google_oauth2 account.'

      # Add a product to the cart with quantity 1
      visit spree.product_path(@product)
      find('#add-to-cart-button').click

      user_order = Spree::Order.last
      expect(user_order.item_count).to eq(1)
      # Logout
      click_link 'Logout'

      # Step 2: As a guest, add a product to the cart with quantity 2
      visit spree.product_path(@product)
      fill_in 'quantity', with: 2
      find('#add-to-cart-button').click

      guest_order = Spree::Order.last
      expect(guest_order.item_count).to eq(2)

      # Step 3: Login again and verify the order is merged
      visit spree.login_path
      click_on 'Login with google_oauth2'
      expect(page).to have_text 'You are now signed in with your google_oauth2 account.'
      merged_order = Spree::Order.last
      expect(merged_order.item_count).to eq(3)
    end
  end
end
