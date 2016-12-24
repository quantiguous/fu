require 'spec_helper'

module Fu
  describe IncomingFileRecordsController do
    before(:each) do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      sign_in @user = Factory(:user)
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
      request.env["HTTP_REFERER"] = "/"
    end

    describe "GET index" do
      it "assigns all incoming_file as @incoming_files" do
        incoming_file = Factory(:incoming_file)
        incoming_file_record = Factory(:incoming_file_record, :incoming_file_id => incoming_file.id)
        get :index, :incoming_file_id => incoming_file.id, :status => 'FAILED'
        assigns(:records).should eq([incoming_file_record])
        assigns(:records_count).should eq(1)
      end
    end

    describe "GET audit_steps" do
      it "assigns all audit_steps as @ic_record_values" do
        incoming_record = Factory(:incoming_file_record)
        a = Factory(:fm_audit_step, :auditable_id => incoming_record.id, :auditable_type => "IncomingFileRecord")
        get :audit_steps, :id => incoming_record.id, :step_name => "ALL"
        assigns(:record_values).should eq([a])
      end
    end
  end
end