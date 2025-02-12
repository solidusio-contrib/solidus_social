# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'main')
gem 'solidus', github: 'solidusio/solidus', branch: solidus_branch

# The solidus_frontend gem has been pulled out since v3.2
if solidus_branch >= 'v3.2'
  gem 'solidus_frontend'
elsif solidus_branch == 'main'
  gem 'solidus_frontend', github: 'solidusio/solidus_frontend'
else
  gem 'solidus_frontend', github: 'solidusio/solidus', branch: solidus_branch
end

rails_version = ENV.fetch('RAILS_VERSION', '7.2')
gem 'rails', "~> #{rails_version}"

# Provides basic authentication functionality for testing parts of your engine
gem 'solidus_auth_devise'

case ENV['DB']
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
else
  gem 'sqlite3', '~> 1.7'
end

gemspec

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g.: `gem 'pry-debug'`.
send :eval_gemfile, 'Gemfile-local' if File.exist? 'Gemfile-local'

gem "csv", "~> 3.3"
