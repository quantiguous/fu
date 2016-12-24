module Fu  
  class IncomingFileRecord < ActiveRecord::Base
    belongs_to :incoming_file
    lazy_load :record_txt, :fault_bitstream
    # audited only: [:should_skip, :overrides]
    has_many :fm_audit_steps, :as => :auditable
  end
end
