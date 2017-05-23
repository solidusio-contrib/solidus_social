require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :requests

  Capybara.javascript_driver = :poltergeist
  Capybara.register_driver(:poltergeist) do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      js_errors: true,
      timeout: 60,
      phantomjs_options: ["--disk-cache=true"]
    )
  end

  config.before(:each, :js) do
    if Capybara.javascript_driver == :selenium
      page.driver.browser.manage.window.maximize
    end
  end
end
