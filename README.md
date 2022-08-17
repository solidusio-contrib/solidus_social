SolidusSocial
=============

[![CircleCI](https://circleci.com/gh/solidusio-contrib/solidus_social.svg?style=svg)](https://circleci.com/gh/solidusio-contrib/solidus_social)
[![Code Climate](https://codeclimate.com/github/solidusio-contrib/solidus_social/badges/gpa.svg)](https://codeclimate.com/github/solidusio-contrib/solidus_social)

Social login support for Solidus. Solidus Social handles authorization, account
creation and association through third-party services.
Currently Github and Google OAuth2 are available out of the box.

Installation
------------

Add solidus_social to your Gemfile:

```ruby
gem 'solidus_social'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_social:install
bundle exec rails db:migrate
```

This will install a new initializer `config/initializers/solidus_social.rb` into
your project that allows you to setup the services you want configured for your app.

Optional: By default the login path will be '/users/auth/:provider'. If you
want something else, configure it in `config/initializers/solidus_social.rb`.


Using OAuth Sources
-------------------

Login as an admin user and navigate to Configuration > Social Authentication Methods

Click "New Authentication Method" and choose one of your configured providers.

**You MUST restart your application after configuring or updating an authentication method.**

Registering Your Application
----------------------------

Github and Google OAuth2 are supported out of the
box but, you will need to register your application with each of the sites you
want to use.

When setting up development applications, keep in mind that most services do
not support `localhost` for your URL/domain. You will need to us a regular
domain (i.e.  `domain.tld`, `hostname.local`) or an IP addresses (`127.0.0.1`).
Make sure you specifity the right IP address.

### Github

[Github / Applications / Register a new OAuth application][4]

1. Name the application.
2. Fill in the details
  - Main URL: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
  - Callback URL: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
4. Click Create.

### Google OAuth2
[Google / APIs / Credentials/ Create Credential](https://console.developers.google.com/)

1. In the APIs and Services dashboard, visit 'Credentials' on the side, then select 'Create Credentials' and 'Oauth client ID'.
2. Name the Application, select "Web Application" as a type.
3. Under "Authorized redirect URIs", add your site (example:
   `http://localhost:3000/users/auth/google_oauth2/callback`)

> More info: [https://developers.google.com/identity/protocols/OAuth2](https://developers.google.com/identity/protocols/OAuth2)

### Other OAuth Providers

Other OAuth providers are supported, given that there is an [OmniAuth
strategy][12] for them. (If there isn't, you can [write one][13].)

#### LinkedIn Example

1. Add `gem "omniauth-linkedin"` to your Gemfile and run `bundle install`.
2. In `config/initializers/solidus_social.rb` add and initialize a new provider
   for SolidusSocial:

   ```ruby

     config.providers = {
       # The configuration key has to match your omniauth strategy.
       linkedin: {
         api_key: ENV['LINKEDIN_API_KEY'],
         api_secret: ENV['LINKEDIN_API_SECRET'],
       },
       # More providers here
   ```
3. Activate your provider as usual.
4. Do **one** of the following:

   - Override the `spree/users/social` view to render OAuth links to display
     your LinkedIn link.
   - Include in your CSS a definition for `.icon-spree-linkedin-circled` and an
     embedded icon font for LinkedIn from [Fontello][14] (the way existing
     icons for Facebook etc are implemented). You can also override
     CSS classes for other providers, `.icon-spree-<provider>-circled`, to use
     different font icons or classic background images, without having to
     override views.

#### Apple Id Example

1. Add `gem "omniauth-apple"` to your Gemfile and run `bundle install`.
2. In `config/initializers/solidus_social.rb` add and initialize a new provider
   for SolidusSocial:

   ```ruby

     config.providers = {
        apple:          {
          icon:   'fa-apple',
          title:  'Apple'
        },
       # More providers here
   ```
   add its configuration after `SolidusSocial.init_providers` line:
   ```ruby
   
     Devise.setup do |config|
       # The configuration key has to match your omniauth strategy.
       config.omniauth :apple, ENV['APPLE_CLIENT_ID'], '',
                       scope:    'email',
                       team_id:  ENV['APPLE_TEAM_ID'],
                       key_id:   ENV['APPLE_KEY_ID'],
                       pem:      ENV['APPLE_PRIVATE_KEY'].gsub('\n', "\n")
     end
   ```
   Notice: APPLE_PRIVATE_KEY should consist from one-line p8-file content, like this `'\n-----BEGIN PRIVATE KEY-----\nsecret\n-----END PRIVATE KEY-----\n'`

Documentation
-------------

API documentation is available [on RubyDoc.info][15].

Contributing
------------

See corresponding [guidelines][11].

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs, and [Rubocop](https://github.com/bbatsov/rubocop) static code analysis. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bin/rake
```

When testing your application's integration with this extension you may use its factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_social/factories'
```

Releasing
---------

Your new extension version can be released using `gem-release` like this:

```shell
bundle exec gem bump -v VERSION --tag --push --remote upstream && gem release
```

License
-------

Copyright (c) 2014 [John Dyer][7] and [contributors][8], released under the [New BSD License][9]

[1]: https://github.com/spree/spree
[3]: https://github.com/settings/applications/new
[4]: http://www.fsf.org/licensing/essays/free-sw.html
[5]: https://github.com/solidusio-contrib/solidus_social/issues
[6]: https://github.com/LBRapid
[7]: https://github.com/solidusio-contrib/solidus_social/graphs/contributors
[8]: https://github.com/solidusio-contrib/solidus_social/blob/master/LICENSE
[9]: https://github.com/solidusio-contrib/solidus_social/blob/master/CONTRIBUTING.md
[10]: https://github.com/intridea/omniauth/wiki/List-of-Strategies
[11]: https://github.com/intridea/omniauth/wiki/Strategy-Contribution-Guide
[12]: http://fontello.com/
[13]: http://www.rubydoc.info/github/solidusio-contrib/solidus_social/
