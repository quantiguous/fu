module Fu
  module IncomingFileHelper
    def find_incoming_files(params)
      incoming_files = IncomingFile
      incoming_files = incoming_files.where("file_type=?",params[:file_type]) if params[:file_type].present?
      incoming_files = incoming_files.where("file_name LIKE ?","#{params[:file_name]}%") if params[:file_name].present?
      incoming_files
    end

    def move_incoming_file(incoming_file)
      sf = CarrierWave::SanitizedFile.new incoming_file.file
      sc_service = incoming_file.sc_service.code.downcase
      file_type = incoming_file.incoming_file_type.code.downcase
      sf.move_to(Rails.root.join(ENV['CONFIG_APPROVED_FILE_UPLOAD_PATH'],sc_service,file_type,incoming_file.file_name), 0666)
    end

    def raw_file_content(file_content_str)
      file_content = nil
      file_content = file_content_str.gsub(/^\s+|\n\s+/, "\n") if file_content_str
      file_content
    end

    def find_logs(params,record)
      if params[:step_name] != 'ALL'
        record.fm_audit_steps.where('step_name=?',params[:step_name]).order("attempt_no desc") rescue []
      else
        record.fm_audit_steps.order("id desc") rescue []
      end      
    end

    def can_select?(record)
      !record.incoming_file_record.fault_code.nil?
    end
  end
end
