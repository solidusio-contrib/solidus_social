# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

solidus_branch = ENV.fetch('SOLIDUS_BRANCH', 'main')
gem 'solidus', github: 'solidusio/solidus', branch: solidus_branch

# The solidus_frontend gem has been pulled out since v3.2
gem 'solidus_frontend'

rails_requirement_string = ENV.fetch('RAILS_VERSION', '~> 7.0')
gem 'rails', rails_requirement_string

# Provides basic authentication functionality for testing parts of your engine
gem 'solidus_auth_devise'

case ENV['DB']
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
else
  rails_version = Gem::Requirement.new(rails_requirement_string).requirements[0][1]
  sqlite_version = rails_version < Gem::Version.new(7.2) ? "~> 1.4" : "~> 2.0"

  gem 'sqlite3', sqlite_version
end

if ["v4.1", "v4.2"].include?(solidus_branch)
  gem "concurrent-ruby", "< 1.3.5"
end

gemspec

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g.: `gem 'pry-debug'`.
send :eval_gemfile, 'Gemfile-local' if File.exist? 'Gemfile-local'
