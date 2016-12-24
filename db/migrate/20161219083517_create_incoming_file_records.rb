class CreateIncomingFileRecords < ActiveRecord::Migration
  def change
    create_table :incoming_file_records, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.integer  :incoming_file_id, :comment => 'the id of the incoming file record'
      t.integer  :record_no, :comment => 'the record number'
      t.text     :record_txt, :comment => 'the record text'
      t.string   :status, :limit=>20, :comment => 'the status of the record'
      t.string   :fault_code, :limit => 50, :comment => "the code that identifies the exception, if an exception occured in the ESB"
      t.string   :fault_subcode, :limit => 50, :comment => "the error code that the third party will return"
      t.string   :fault_reason, :limit => 1000, :comment => "the english reason of the exception, if an exception occurred in the ESB"
      t.datetime :created_at, :null=>false, :comment => 'the datetime the record was created'
      t.datetime :updated_at, :comment => 'the datetime the record was created'
      t.text     :fault_bitstream, :comment => 'the fault bitstream'
      t.string   :rep_status, :limit => 50, :comment => 'the status of the response'
      t.string   :rep_fault_code, :limit=>50, :comment => 'the code that identifies the exception in response'
      t.string   :rep_fault_subcode, :limit=>50, :comment => 'the error code that the third party will return'
      t.string   :rep_fault_reason, :limit=>500, :comment => 'the english reason of the exception in response'
      t.text     :rep_fault_bitstream, :comment => 'the fault bitstream of response'
      t.string   :overrides, :limit=>50, :comment => "the indicator that tells whether the record is overriden"
      t.integer  :attempt_no, :comment => "the attempt no returned in the response by the api" 
    end

      add_index :incoming_file_records, [:incoming_file_id, :record_no], name: "in_file_records_1", unique: true
  end
end
