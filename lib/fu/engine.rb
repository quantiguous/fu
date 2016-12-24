require 'will_paginate'
require 'responders'
require 'unscoped_associations'
require 'haml-rails'
require 'simple_form'
module Fu
  class Engine < ::Rails::Engine
    isolate_namespace Fu

    config.autoload_paths << File.expand_path('../views', __FILE__)

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.template_engine :haml
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match "#{root}/"
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end
  end

  # Don't have prefix method return anything.
  # This will keep Rails Engine from generating all table prefixes with the engines name
  def self.table_name_prefix
  end
end
