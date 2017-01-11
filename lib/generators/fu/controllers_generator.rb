require 'rails/generators/base'

module Fu
  class ControllersGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates/controllers", __FILE__)
    argument :name, :type => :string, :default => '{module}'

    def create_controllers
      template "module_incoming_records_controller.rb", "app/controllers/#{name}_incoming_records_controller.rb"
    end
  end
end
