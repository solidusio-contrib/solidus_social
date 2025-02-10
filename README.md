SolidusSocial
=============

[![CircleCI](https://circleci.com/gh/solidusio-contrib/solidus_social.svg?style=svg)](https://circleci.com/gh/solidusio-contrib/solidus_social)

Social login support for Solidus. Solidus Social handles authorization, account
creation and association through third-party services.
Currently Google, Facebook, Github and X (formely Twitter) are available out of the box.
Support for Apple ID and Microsoft (Entra and O365) might be offered down the road. 

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

Preference(optional): By default the login path will be `/users/auth/:provider`. If you wish to modify the url to: 
`/member/auth/:provider`, `/profile/auth/:provider`, or `/auth/:provider` then you can do this accordingly in 
your **config/initializers/spree.rb** file as described below:

```ruby
Spree::SocialConfig[:path_prefix] = 'member'  # for /member/auth/:provider
Spree::SocialConfig[:path_prefix] = 'profile' # for /profile/auth/:provider
Spree::SocialConfig[:path_prefix] = ''        # for /auth/:provider
```

Using OAuth Sources
-------------------

Login as an admin user and navigate to Configuration > Social Authentication Methods

Click "New Authentication Method" and choose one of your configured providers.

Click on the New Authentication Method button to enter the key obtained from their respective source, (See below for instructions on setting up the various providers).

Multiple key entries can now be entered based on the rails environment. This allows for portability and the lack of need to check in your key to your repository. You also have the ability to enable and disable sources. These setting will be reflected on the client UI as well.

Alternatively you can ship keys as environment variables and create these Authentication Method records on application boot via an initializer. Below is an example for facebook.

```ruby
# Ensure our environment is bootstrapped with a facebook connect app
if ActiveRecord::Base.connection.data_source_exists? 'spree_authentication_methods'
  Spree::AuthenticationMethod.where(environment: Rails.env, provider: 'facebook').first_or_create do |auth_method|
    auth_method.api_key = ENV['FACEBOOK_APP_ID']
    auth_method.api_secret = ENV['FACEBOOK_APP_SECRET']
    auth_method.active = true
  end
end
```

**You MUST restart your application after configuring or updating an authentication method.**

Registering Your Application
----------------------------

OAuth Applications @ Facebook, Twitter, Google and / or Github are supported out of the
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

### Twitter
[Twitter / Application Management / Create an application](https://docs.x.com/resources/fundamentals/authentication/oauth-2-0/overview)

1. Name and Description must be filled in with something
2. Configure user authentication setting with:
 - App permissions: Read (default) and enable Request email from users option.
 - Application Website: http://your_computer.local:3000 for development / http://your-site.com for production
 - Application Type: Web App, Automated App or Bot
 - Callback URL: http://your_computer.local:3000 for development / http://your-site.com for production
3. Save Application

### Adding other OAuth sources

It is easy to add any OAuth source, given there is an OmniAuth strategy gem for it (and if not, you can easily write one by yourself). For instance, if you want to add authorization via LinkedIn, the steps will be:
1. Add gem `"omniauth-linkedin"` to your Gemfile, run `bundle install`.
2. In an initializer file, e.g. `config/initializers/devise.rb`, add and init a new provider for SolidusSocial:

**Optional:** If you want to skip the sign up phase where the user has to provide an email and a password, add a third parameter to the provider entry and the Spree user will be created directly using the email field in the [Auth Hash Schema](https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema):

```ruby
Provider = Struct.new(:title, :key, :skip_signup)
SolidusSocial::OAUTH_PROVIDERS << Provider.new("LinkedIn", "linkedin", true)
SolidusSocial.init_provider('linkedin')
```
3. Activate your provider as usual (via initializer or admin interface).
4. Do **one** of the following:

   - For legacy frontend, override the `spree/users/social` view to render OAuth links to display
     your LinkedIn link and for starter frontend override `spree/starter_frontend/shared/social`.
   - Include in your CSS a definition for `.icon-spree-linkedin-circled` and an
     embedded icon font for LinkedIn from [Fontello](12) (the way existing
     icons for Facebook etc are implemented). You can also override
     CSS classes for other providers, `.icon-spree-<provider>-circled`, to use
     different font icons or classic background images, without having to
     override views.

Documentation
-------------

API documentation is available [on RubyDoc.info][13].

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
[2]: https://developers.facebook.com/apps/?action=create
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
