# frozen_string_literal: true

module SolidusSocial
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root "#{__dir__}/templates"

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_stylesheets
        inject_into_file "vendor/assets/stylesheets/spree/frontend/all.css", " *= require spree/frontend/solidus_social\n", before: %r{\*/}, verbose: true
      end

      def add_migrations
        run "bin/rails railties:install:migrations FROM=solidus_social"
      end

      def copy_initializer
        template "config/initializers/solidus_social.rb"
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ["", "y", "Y"].include?(ask("Would you like to run the migrations now? [Y/n]"))
        if run_migrations
          run "bin/rails db:migrate"
        else
          puts "Skipping bin/rails db:migrate, don't forget to run it!"
        end
      end
    end
  end
end
