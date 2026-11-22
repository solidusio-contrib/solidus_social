# frozen_string_literal: true

RSpec.describe "Admin authentication methods" do
  stub_authorization!

  describe "POST /admin/authentication_methods" do
    it "creates an authentication method from the permitted attributes" do
      post spree.admin_authentication_methods_path, params: {
        authentication_method: {
          environment: "test",
          provider: "github",
          active: true,
          api_key: "KEY",
          api_secret: "SECRET"
        }
      }

      expect(response).to redirect_to(spree.admin_authentication_methods_path)
      expect(Spree::AuthenticationMethod.last).to have_attributes(
        environment: "test",
        provider: "github",
        active: true,
        api_key: nil,
        api_secret: nil
      )
    end
  end

  describe "PUT /admin/authentication_methods/:id" do
    it "updates the authentication method" do
      authentication_method = Spree::AuthenticationMethod.create!(
        environment: "test",
        provider: "github",
        active: true
      )

      put spree.admin_authentication_method_path(authentication_method), params: {
        authentication_method: {provider: "facebook", active: false}
      }

      expect(response).to redirect_to(spree.admin_authentication_methods_path)
      expect(authentication_method.reload).to have_attributes(provider: "facebook", active: false)
    end
  end
end
