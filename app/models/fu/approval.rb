module Fu 
  module Approval  
    extend ActiveSupport::Concern
    included do
      # audited except: [:approval_status, :last_action]

      belongs_to :unapproved_record, :primary_key => 'approved_id', :foreign_key => 'id', :class_name => self.name, :unscoped => true
      belongs_to :approved_record, :foreign_key => 'approved_id', :primary_key => 'id', :class_name => self.name, :unscoped => true

      validates_uniqueness_of :approved_id, :allow_blank => true
      validate :validate_unapproved_record

      def self.default_scope
        where approval_status: 'A'
      end
    end

    def validate_unapproved_record
      errors.add(:base,"Unapproved Record Already Exists for this record") if !unapproved_record.nil? and (approval_status == 'A' and approval_status_was == 'A')
    end

    def approve
      return "The record version is different from that of the approved version" if !self.approved_record.nil? and self.approved_version != self.approved_record.lock_version    

    #    make the U the A record, also assign the id of the A record, this looses history
    #    self.approval_status = 'A'
    #    self.approved_record.delete unless self.approved_record.nil?
    #    self.update_column(:id, self.approved_id) unless self.approved_id.nil?   
    #    self.approved_id = nil


      if self.approved_record.nil?
        # create action, all we need to do is set the status to approved
        self.approval_status = 'A'
      else
        # copy all attributes of the U record to the A record, and delete the U record
        attributes = self.attributes.select do |attr, value|
          self.class.column_names.include?(attr.to_s) and 
          ['id', 'approved_id', 'approval_status', 'lock_version', 'approved_version', 'created_at', 'updated_at', 'updated_by', 'created_by'].exclude?(attr)
        end
        
        self.class.unscoped do
          approved_record = self.approved_record
          approved_record.assign_attributes(attributes)
          approved_record.last_action = 'U'
          approved_record.updated_by = self.created_by
          self.destroy
          # not enought time to test cases where the approval is being done after changes in validations of the model, such that the saving of the approved 
          # record fails, this can be fixed to return the errors so that they can be shown to the user
          approved_record.save!
        end
      end
      
      return ""
    end

    def enable_approve_button?
      self.approval_status == 'U' ? true : false
    end
  end
end
