## Unreleased

## v1.3.0

- Migrated factories from FactoryGirl to FactoryBot
- Add support for Solidus 2.4+
- Reduced compatible versions of `solidus_core` to 2.x
- Removed the deprecated `icon:` argument from admin buttons
- Fixed an issue when using Safari to authenticate
- `Spree::UserRegistrationsController` and `Spree.user_class` are now decorated by
  prepending modules in the `SolidusSocial::Spree` namespace instead of using `class_eval`
- Development of the extension is not relying on `solidus_dev_support` and CircleCI
- Moved the Facebook strategy patch to it's own prepended module

## v1.2.0

- Switched to using the install generator to import the solidus social
  initializer into apps. **Please run `bin/rails generate solidus_social:install`
  in order to upgrade.**
- Removed the `SolidusSocial::OAUTH_PROVIDERS` constant in favour of
  the `Spree::AuthenticationMethod.providers_options` class
  method. This is populated using the `Spree::SocialConfig#providers` Hash.
- Added support for Rails 5.1.
- Added Italian translations

## v1.1.0

- Added support for Solidus 2/Rails 5
- Bugfixes

## v1.0.0

- Renamed SpreeSocial to SolidusSocial
- Relaxed versions to support solidus 1.0+
- Port of https://github.com/DynamoMTL/spree_social's solidus branch
