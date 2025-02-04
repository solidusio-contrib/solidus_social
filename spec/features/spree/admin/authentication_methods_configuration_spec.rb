# frozen_string_literal: true

RSpec.describe 'Admin Authentication Methods', :js do
  stub_authorization!

  context 'elements' do
    it 'has configuration tab' do
      visit spree.admin_path
      click_link 'Settings'
      expect(page).to have_text(/Social Auth/i)
    end
  end

  context 'when no auth methods exists' do
    before do
      visit spree.admin_path
      click_link 'Settings'
      click_link 'Social Auth'
    end

    it 'can create new' do
      expect(page).to have_text 'No Authentication Methods Found, Add One!'

      click_link 'New Authentication Method'
      select2 'Test', from: 'Environment'
      select2 'Github', from: 'Social Provider'
      fill_in 'API Key', with: 'test_api_key'
      fill_in 'API Secret', with: 'test_api_secret'

      click_button 'Create'
      expect(page).to have_text 'successfully created!'
    end
  end

  context 'when auth method exists' do
    let!(:authentication_method) do
      Spree::AuthenticationMethod.create!(
        provider: 'facebook',
        api_key: 'fake',
        api_secret: 'fake',
        environment: Rails.env,
        active: true
      )
    end

    before do
      visit spree.admin_path
      click_link 'Settings'
      click_link 'Social Auth'
    end

    it 'can be updated' do
      within_row(1) do
        click_icon :edit
      end

      find('#authentication_method_active_false').click

      click_button 'Update'
      expect(page).to have_text 'successfully updated!'
    end

    it 'can be deleted' do
      accept_confirm do
        within_row(1) do
          click_icon :trash
        end
      end

      expect(page).to have_text 'successfully removed!'
      expect(page).not_to have_text authentication_method.provider
    end
  end
end
