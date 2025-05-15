# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'solidus_dev_support/rake_tasks'
SolidusDevSupport::RakeTasks.install(user_class: "Spree::User")

task default: 'extension:specs'
