module Fu
  class IncomingFile < ActiveRecord::Base  
    lazy_load :fault_bitstream

    SIZE_LIMIT = 50.megabytes.to_i
    validate :validate_file_name 
    validate :validate_unique_file
    validate :file_size, :on => [:create]

    validates_presence_of :service_name, :file_type
    validates :file_name, length: { maximum: 100 }

    BlackList = %w(exe vbs rb sh jar html msi bat com bin vb doc docx xlsx jpeg gif pdf png zip jpg)

    ExtensionList = %w(txt csv)

    before_create :update_fields

    before_save :update_file_path

    belongs_to :created_user, :class_name => 'User', :foreign_key => 'created_by'
    belongs_to :updated_user, :class_name => 'User', :foreign_key => 'updated_by'
    belongs_to :sc_service, :foreign_key => 'service_name', :primary_key => 'code'
    belongs_to :incoming_file_type, :foreign_key => 'file_type', :primary_key => 'code'
    has_many :failed_records, -> { where status: 'FAILED' }, class_name: 'IncomingFileRecord'
    has_many :incoming_file_records
    has_many :fm_audit_steps, :as => :auditable

    mount_uploader :file, IncomingFileUploader

    validates_presence_of :file, :on => :create
    
    def name
      file_name
    end

    def file_size
      unless file.file.nil?
        if file.file.size.to_f/(1000*1000) > SIZE_LIMIT.to_f/(1000*1000)
          limit = SIZE_LIMIT/(1000*1000).to_i
          errors.add(file.filename, "cannot be greater than #{limit} MB")
        end
      end
    end

    def validate_file_name
      p file
      if file.filename.present?
        file.filename.split(".").each do |ext|
          errors.add(:file, "Invalid file extension") and return false if BlackList.include?(ext)
        end
        errors.add(:file, "name length is more than 100") if file.filename.length > 100
      end
    end

    def validate_unique_file
      if file.filename.present?
        if IncomingFile.unscoped.where("file_name=?",file.filename).count > 0
          errors.add(:file, "'#{file.file.original_filename}' already exists") and return false
        end
      end
    end

    def update_fields
      self.size_in_bytes = self.file.file.try(:size).to_s
      self.line_count =  File.readlines(self.file.path).size
      self.file_name = self.file.filename if file_name.nil?
      self.failed_record_count = 0
      self.record_count = 0
      self.skipped_record_count = 0
      self.completed_record_count = 0
      self.timedout_record_count = 0
      self.alert_count = 0
      self.pending_approval = 'N'
    end

    def update_file_path
      self.file_path = "#{ENV['CONFIG_APPROVED_FILE_UPLOAD_PATH']}/#{self.sc_service.code.downcase}/#{self.incoming_file_type.code.downcase}"
    end

    def job_status
      pending_approval == 'Y' ? "Pending Approval" : status_text(status)
    end
    
    def status_text(status_code)
      list = {'N': 'Not Started', 'I': 'In Progress', 'C': 'Completed', 'F': 'Failed'}
      status_code.nil? ? nil : list[status_code.to_sym]
    end

    def upload_time
      (ended_at - started_at).round(2).to_s + ' Secs' rescue '-'
    end

    def auto_upload?
      incoming_file_type.auto_upload == 'Y'
    end
  end
end
