# frozen_string_literal: true

require_relative 'lib/solidus_social/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_social'
  spec.version = SolidusSocial::VERSION
  spec.authors = ['John Dyer']
  spec.email = 'jdyer@spreecommerce.com'

  spec.summary = 'Adds social network login services (OAuth) to Solidus'
  spec.homepage = 'https://github.com/solidusio-contrib/solidus_social#readme'
  spec.license = 'BSD-3-Clause'


  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_social'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio-contrib/solidus_social/blob/master/CHANGELOG.md'

  spec.required_ruby_version = '>= 2.4'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }
  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'deface'
  spec.add_dependency 'oa-core'
  spec.add_dependency 'omniauth', '~> 1.9.1'
  spec.add_dependency 'omniauth-github'
  spec.add_dependency 'omniauth-google-oauth2'
  spec.add_dependency 'solidus_auth_devise'
  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 4']
  spec.add_dependency 'solidus_support', '~> 0.5'

  spec.add_development_dependency 'solidus_dev_support'
end
