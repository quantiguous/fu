class CreateIncomingFiles < ActiveRecord::Migration
  def change
    create_table :incoming_files, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string   :service_name, :limit=>10, :comment => 'the name of the service'
      t.string   :file_type, :limit=>10, :comment => 'the code of the incoming file type'
      t.string   :file, :comment => 'the uploaded file'
      t.string   :file_name, :limit=>100, :comment => 'the name of the uploaded file'
      t.integer  :size_in_bytes, :comment => 'the size of the file in bytes'
      t.integer  :line_count, :comment => 'the line count of the files'
      t.string   :status, :limit=>1, :comment => 'the status of the upload'
      t.date     :started_at, :comment => 'the datetime when the file was picked up for processing'
      t.date     :ended_at, :comment => 'the datetime when the file processing completed'
      t.string   :created_by, :limit=>20, :comment => 'the person who uploaded the record'
      t.string   :updated_by, :limit=>20, :comment => 'the person who updated the record'
      t.datetime :created_at, :null=>false, :comment => 'the datetime the record was created'
      t.datetime :updated_at, :comment => 'the datetime the record was created'
      t.string   :fault_code, :limit => 50, :comment => "the code that identifies the exception, if an exception occured in the ESB"
      t.string   :fault_subcode, :limit => 50, :comment => "the error code that the third party will return"
      t.string   :fault_reason, :limit => 1000, :comment => "the english reason of the exception, if an exception occurred in the ESB"
      t.string   :approval_status, :limit => 1, :default => 'U', :null => false, :comment => "the indicator to denote whether this record is pending approval or is approved"
      t.string   :last_action, :limit => 1, :default => 'C', :null => false, :comment => "the last action (create, update) that was performed on the record"
      t.integer  :approved_version, :comment => "the version number of the record, at the time it was approved"
      t.integer  :approved_id, :comment => "the id of the record that is being updated"
      t.integer  :lock_version, :null => false, :default => 0, :comment => "the version number of the record, every update increments this by 1"
      t.string   :broker_uuid, :limit=>255, :comment => 'the broker uuid'
      t.integer  :failed_record_count, :comment => 'the count of failed records'
      t.string   :rep_file_name, :comment => 'the name of the response file'
      t.string   :rep_file_path, :comment => 'the path of the response file'
      t.string   :rep_file_status, :limit=>1, :comment => 'the status of the response file'
      t.string   :pending_approval, :limit=>1, :comment => 'the flag to indicate if approval is pending'
      t.string   :file_path, :comment => 'the path of the uploaded file'
      t.string   :last_process_step, :limit=>1, :comment => 'the last step of the process'
      t.integer  :record_count, :comment => 'the total count of records in the file'
      t.integer  :skipped_record_count, :comment => 'the count of skipped records in the file'
      t.integer  :completed_record_count, :comment => 'the count of completed records in the file'
      t.integer  :timedout_record_count, :comment => 'the count of timedout records in the file'
      t.integer  :alert_count, :comment => 'the count of alert'
      t.datetime :last_alert_at, :comment => 'the datetime when last alert was sent'
      t.integer  :bad_record_count, :comment => 'the count of bad records in the table'
      t.text     :fault_bitstream, :comment => 'the fault bitstream'
      t.integer  :pending_retry_record_count, :comment => 'the count of pending retry records in the file'
      t.integer  :overriden_record_count, :comment => 'the count of overriden records in the file'
      t.string   :nack_file_name, :limit=>150, :comment => 'the name of the nack file'
      t.string   :nack_file_path, :comment => 'the path of the nack file'
      t.string   :nack_file_status, :limit=>1, :comment => 'the status of the nack file'
      t.text     :header_record, :comment => 'the header record of the file'
    end

    add_index :incoming_files, [:file_name, :approval_status], name: "in_incoming_files_1", unique: true
    add_index :incoming_files, [:service_name, :status, :pending_approval], name: "in_incoming_files_2"
  end
end
