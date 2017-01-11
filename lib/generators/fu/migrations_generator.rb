require 'rails/generators/active_record'

module Fu
  # Migration generator that creates migration file from template
  class MigrationsGenerator < ActiveRecord::Generators::Base
    source_root File.expand_path("../templates/migrations", __FILE__)

    argument :name, :type => :string, :default => '{module}'
    # Create migration in project's folder
    def generate_files
      migration_template 'module_incoming_records.rb', "db/migrate/create_#{name}_incoming_records.rb"
      migration_template 'module_incoming_files.rb', "db/migrate/create_#{name}_incoming_files.rb"
    end
  end
end
