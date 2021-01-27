class OmniauthSetup
  # OmniAuth expects the class passed to setup to respond to the #call method.
  # env - Rack environment
  def self.call(env)
    new(env).setup
  end

  # Assign variables and create a request object for use later.
  # env - Rack environment
  def initialize(env)
    @env = env
    @request = ActionDispatch::Request.new(env)
  end

  # The main purpose of this method is to set the consumer key and secret.
  def setup
    @env['omniauth.strategy'].options.merge!(custom_credentials)
  end

  private

  # Use the subdomain in the request to find the account with credentials
  def custom_credentials
    store = Spree::Config.current_store_selector_class.new(@request).store
    provider = @env['omniauth.strategy'].options[:name]

    authentication_method = Spree::AuthenticationMethod.find_by(provider: provider, store: store)

    {
        client_id: authentication_method.api_key,
        client_secret: authentication_method.api_secret,
        client_options: {
            site: authentication_method.site
        }
    }
  end
end
