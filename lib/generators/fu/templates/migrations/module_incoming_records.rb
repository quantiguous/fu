class Create<%= name.camelize %>IncomingRecords < ActiveRecord::Migration
  def self.up
    create_table :<%= name %>_incoming_records, {:sequence_start_value => '1 cache 20 order increment by 1'} do |table|
      table.integer :incoming_file_record_id, comment: 'the id of the incoming file record'
      table.string :file_name, limit: 100, comment: 'the name of the file'
    end
    add_index "<%= name %>_incoming_records", ["incoming_file_record_id"], name: "<%= name %>_incoming_records_01", unique: true
  end

  def self.down
    drop_table :<%= name %>_incoming_records
  end
end