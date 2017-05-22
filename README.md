# Solidus Social

[![Build Status](https://travis-ci.org/solidusio-contrib/solidus_social.svg?branch=master)](https://travis-ci.org/solidusio-contrib/solidus_social)
[![Code Climate](https://codeclimate.com/github/solidusio-contrib/solidus_social/badges/gpa.svg)](https://codeclimate.com/github/solidusio-contrib/solidus_social)

Social login support for Solidus. Solidus Social handles authorization, account
creation and association through third-party services. Currently Twitter,
Facebook, Github, Google OAuth2, and Amazon are available out of the box.

## Installation

Add this extension to your `Gemfile`:

```ruby
gem 'solidus_social', github: 'solidusio-contrib/solidus_social'
```

Then run:

```sh
$ bundle && bundle exec rails g solidus_social:install
$ bundle exec rake db:migrate
```

This will install a new initializer `config/initializers/solidus_social.rb` into
your project that allows you to setup the services you want configured for your app.

Optional: By default the login path will be '/users/auth/:provider'. If you
want something else, configure it in `config/initializers/solidus_social.rb`.


## Using OAuth Sources

Login as an admin user and navigate to Configuration > Social Authentication Methods

Click "New Authentication Method" and choose one of your configured providers.

**You MUST restart your application after configuring or updating an authentication method.**

## Registering Your Application

Facebook, Twitter, Github, Google OAuth2, and Amazon are supported out of the
box but, you will need to register your application with each of the sites you
want to use.

When setting up development applications, keep in mind that most services do
not support `localhost` for your URL/domain. You will need to us a regular
domain (i.e.  `domain.tld`, `hostname.local`) or an IP addresses (`127.0.0.1`).
Make sure you specifity the right IP address.

### Facebook

[Facebook / Developers / Apps][2]

1. Name the app and agree to the terms.
2. Fill out the capcha.
3. Under the "Web Site" tab enter:
  - Site URL: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
  - Site domain: `yourhostname.local` and `your-site.com` respectively

### Twitter

[Twitter / Application Management / Create an application][3]

1. Fill in the name and description.
2. Fill in the rest of the details:
  - Application Website: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
  - Application Type: "Browser"
  - Callback URL: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
  - Default Access Type: "Read & Write"
6. Save the application.

### Github

[Github / Applications / Register a new OAuth application][4]

1. Name the application.
2. Fill in the details
  - Main URL: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
  - Callback URL: `http://yourhostname.local:3000` for development and
    `http://your-site.com` for production
4. Click Create.

### Amazon

[Amazon / App Console / Register a new OAuth application][10]

1. Register New Application.
2. Name the Application, provide description and URL for Privacy Policy.
3. Click Save.
4. Add Your site under Web Settings > Allowed Return URLs (example:
   `http://localhost:3000/users/auth/amazon/callback`)

> The app console is available at [https://login.amazon.com/manageApps](https://login.amazon.com/manageApps)

### Google OAuth2

_TODO: Write instructions._

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
     icons for Facebook, Twitter, etc are implemented). You can also override
     CSS classes for other providers, `.icon-spree-<provider>-circled`, to use
     different font icons or classic background images, without having to
     override views.

## Documentation

API documentation is available [on RubyDoc.info][15].

## Contributing

See corresponding [guidelines][11].

Copyright (c) 2014 [John Dyer][7] and [contributors][8], released under the [New BSD License][9]

[1]: https://github.com/spree/spree
[2]: https://developers.facebook.com/apps/?action=create
[3]: https://apps.twitter.com/app/new
[4]: https://github.com/settings/applications/new
[5]: http://www.fsf.org/licensing/essays/free-sw.html
[6]: https://github.com/solidusio-contrib/solidus_social/issues
[7]: https://github.com/LBRapid
[8]: https://github.com/solidusio-contrib/solidus_social/graphs/contributors
[9]: https://github.com/solidusio-contrib/solidus_social/blob/master/LICENSE.md
[10]: https://login.amazon.com/manageApps
[11]: https://github.com/solidusio-contrib/solidus_social/blob/master/CONTRIBUTING.md
[12]: https://github.com/intridea/omniauth/wiki/List-of-Strategies
[13]: https://github.com/intridea/omniauth/wiki/Strategy-Contribution-Guide
[14]: http://fontello.com/
[15]: http://www.rubydoc.info/github/solidusio-contrib/solidus_social/
