require 'spec_helper'

module Fu
  describe FmAuditStep, type: :model do
    context 'association' do
      it { should belong_to(:auditable) }
    end

    context "response_time" do 
      it "should return difference between rep_timestamp and req_timestamp" do 
        a = Factory(:fm_audit_step, :rep_timestamp => Time.now.advance(:minutes => 1), :req_timestamp => Time.now)
        a.response_time.should == 60000
      end
    end
  end
end