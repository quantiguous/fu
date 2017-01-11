class <%= name.camelize %>IncomingRecord < ActiveRecord::Base
  belongs_to :incoming_file_record, :class_name => 'Fu::IncomingFileRecord'
  belongs_to :incoming_file, :foreign_key => 'file_name', :primary_key => 'file_name', :class_name => 'Fu::IncomingFile'
end