module Fu
  class FmAuditStep < ActiveRecord::Base  
    belongs_to :auditable, :polymorphic => true
    
    def response_time
      ((self.rep_timestamp - self.req_timestamp) * 1000).round rescue '0'
    end
  end
end
