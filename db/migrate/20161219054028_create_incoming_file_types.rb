class CreateIncomingFileTypes < ActiveRecord::Migration
  def change
    create_table :incoming_file_types, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.integer :sc_service_id, :null=>false, :comment => 'the id of the sc service'
      t.string  :code, :limit=>50, :null=>false, :comment => 'the code for the file type'
      t.string  :name, :limit=>50, :null=>false, :comment => 'the name for the file type'
      t.string  :msg_domain, :limit=>255, :comment => 'the message domain'
      t.string  :msg_model, :limit=>255, :comment => 'the message model'
      t.string  :validate_all, :limit=>1, :default=>"N", :comment => 'the flag to indicate whether the file contents should be validated'
      t.string  :auto_upload, :limit=>1, :default=>"N", :comment => 'the flag to indicate whether the file is auto upload'
      t.string  :skip_first, :limit=>1, :default=>"N", :comment => 'the flag to indicate if the first row in the file should be skipped'
      t.string  :build_response_file, :limit=>1, :comment => 'flag to indicate if response file should be built'
      t.string  :correlation_field, :comment
      t.string  :db_unit_name, :comment => 'the database unit name'
      t.string  :records_table, :comment => 'the name of the table in the module'
      t.string  :can_override, :limit=>1, :default=>"N", :null=>false, :comment => 'the flag to indicate if the records can be overrided'
      t.string  :can_skip, :limit=>1, :default=>"N", :null=>false, :comment => 'the flag to indicate if the record can be skipped'
      t.string  :can_retry, :limit=>1, :default=>"N", :null=>false, :comment => 'the flag to indicate if the file can be retried'
      t.string  :build_nack_file, :limit=>1, :default=>"N", :null=>false, :comment => 'the flag to indicate if nack file to be built'
      t.string  :skip_last, :limit=>1, :default=>"N", :null=>false, :comment => 'the flag to indicate if the last record in file can be skipped'
    end

    add_index :incoming_file_types, [:sc_service_id, :code], :unique => true, :name => 'in_file_types_1'
  end
end
