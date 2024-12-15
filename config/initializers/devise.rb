# frozen_string_literal: true

SolidusSocial::OAUTH_PROVIDERS.each do |provider|
  SolidusSocial.init_provider(provider[1])
end

OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = 'omniauth'

OmniAuth.config.on_failure = proc do |env|
  env['devise.mapping'] = Devise.mappings[Spree.user_class.table_name.singularize.to_sym]
  controller_klass = ActiveSupport::Inflector.constantize("Spree::OmniauthCallbacksController")
  controller_klass.action(:failure).call(env)
end

Devise.setup do |config|
  config.router_name = :spree
end
