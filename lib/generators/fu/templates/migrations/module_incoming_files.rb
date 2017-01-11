class Create<%= name.camelize %>IncomingFiles < ActiveRecord::Migration
  def self.up
    create_table :<%= name %>_incoming_files, {:sequence_start_value => '1 cache 20 order increment by 1'} do |table|
      table.string :file_name, limit: 100, comment: 'the name of the file'
    end
    add_index "<%= name %>_incoming_files", ["file_name"], name: "<%= name %>_incoming_files_01", unique: true
  end

  def self.down
    drop_table :<%= name %>_incoming_files
  end
end
