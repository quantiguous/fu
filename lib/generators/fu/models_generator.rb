require 'rails/generators/base'

module Fu
  class ModelsGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates/models", __FILE__)
    argument :name, :type => :string, :default => '{module}'

    def create_models
      template "module_incoming_record.rb", "app/models/#{name}_incoming_record.rb"
      template "module_incoming_file.rb", "app/models/#{name}_incoming_file.rb"
    end
  end
end
