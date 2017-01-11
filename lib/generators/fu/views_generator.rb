require 'rails/generators/base'

module Fu
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates/views", __FILE__)
    argument :name, :type => :string, :default => '{module}'

    def create_views
      template "incoming_file_summary.rb", "app/views/#{name}_incoming_records/incoming_file_summary.html.haml"
      template "show.rb", "app/views/#{name}_incoming_records/show.html.haml"
      template "api_buttons.rb", "app/views/incoming_records/_api_buttons.html.haml"
      template "index.rb", "app/views/#{name}_incoming_records/index.html.haml"
    end
  end
end
