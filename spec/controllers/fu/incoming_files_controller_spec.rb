require 'spec_helper'

module Fu
  describe IncomingFilesController do

    before(:each) do
      @controller.instance_eval { flash.extend(DisableFlashSweeping) }
      sign_in @user = Factory(:user)
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
      request.env["HTTP_REFERER"] = "/"
    end

    describe "GET index" do
      it "assigns all incoming_file as @incoming_files" do
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        get :index, {:sc_service => incoming_file.service_name}
        assigns(:incoming_files).should eq([incoming_file])
        FileUtils.rm_f 'Test2.exe.txt'
      end

      it "assigns all unapproved incoming_files as @incoming_files when approval_status is passed" do
        incoming_file = Factory(:incoming_file, :approval_status => 'U')
        get :index, {:sc_service => incoming_file.service_name, :approval_status => 'U'}
        assigns(:incoming_files).should eq([incoming_file])
        FileUtils.rm_f 'Test2.exe.txt'
      end
    end

    describe "GET audit_steps" do
      it "assigns all audit_steps as @file_record_values" do
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        a = Factory(:fm_audit_step, :auditable_id => incoming_file.id, :auditable_type => "IncomingFile")
        get :audit_steps, :id => incoming_file.id, :step_name => "ALL"
        assigns(:file_record_values).should eq([a])
      end
    end

    describe "GET view_raw_content" do
      it "should display raw content of a file" do
        incoming_file = Factory(:incoming_file)
        get :view_raw_content, {:id => incoming_file.id}
        file_extension = Rack::Mime::MIME_TYPES.invert[incoming_file.file.content_type].split(".").last
        file_extension.should == IncomingFile::ExtensionList[0]
        file_abs_url = "#{incoming_file.file.file.instance_variable_get :@file}"
        file_abs_url.should == "#{incoming_file.file.file.instance_variable_get :@file}"
        expect(IncomingFile).to receive(:`).exactly(0).times.with("cat -ne #{file_abs_url}")
        response.should render_template("view_raw_content")
        response.status.should eq(200)
      end
    end

    describe "GET show" do
      it "assigns the requested incoming_file as @incoming_file" do
        incoming_file = Factory(:incoming_file)
        get :show, {:id => incoming_file.id}
        assigns(:incoming_file).should eq(incoming_file)
      end
    end
    
    describe "GET new" do
      it "assigns a new incoming_file as @incoming_file" do
        get :new
        assigns(:incoming_file).should be_a_new(IncomingFile)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new incoming_file" do
          params = Factory.attributes_for(:incoming_file)
          expect {
            post :create, {:incoming_file => params}
          }.to change(IncomingFile.unscoped, :count).by(1)
          flash[:alert].should  match(/File is successfully uploaded/)
          response.should be_redirect
        end

        it "assigns a newly created saving as @incoming_file" do
          params = Factory.attributes_for(:incoming_file)
          post :create, {:incoming_file => params}
          assigns(:incoming_file).should be_a(IncomingFile)
          assigns(:incoming_file).should be_persisted
        end

        it "redirects to the created incoming_file" do
          params = Factory.attributes_for(:incoming_file)
          post :create, {:incoming_file => params}
          response.should redirect_to(:action => :index)
        end

        it "re-renders the 'new' template when show_errors is true" do
          params = Factory.attributes_for(:incoming_file, :file => nil)
          post :create, {:incoming_file => params}
          response.should render_template("new")
        end
      end
    end

    describe 'DESTROY' do 
      it "should destroy the incoming_file" do 
        incoming_file = Factory(:incoming_file)
        delete :destroy, {:id => incoming_file.id}
        IncomingFile.unscoped.find_by_id(incoming_file.id).should be_nil
      end

      it "should destroy the incoming_file" do 
        incoming_file = Factory(:incoming_file, :status => "I")
        delete :destroy, {:id => incoming_file.id}
        flash[:alert].should  match(/delete is disabled since the file has already been proccessed/)
        IncomingFile.unscoped.find_by_id(incoming_file.id).should_not be_nil
      end
    end

    # describe "PUT approve" do
    #   it "unapproved record can be approved and old approved record will be deleted" do
    #     user_role = UserRole.find_by_user_id(@user.id)
    #     user_role.delete
    #     Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
    #     incoming_file1 = Factory(:incoming_file, :approval_status => 'A')
    #     incoming_file2 = Factory(:incoming_file, :approval_status => 'U', :approved_version => incoming_file1.lock_version, :approved_id => incoming_file1.id)
    #     put :approve, {:id => incoming_file2.id}
    #     incoming_file2.reload
    #     incoming_file2.approval_status.should == 'A'
    #     IncomingFile.find_by_id(incoming_file1.id).should be_nil
    #     File.file?(Rails.root.join(ENV['CONFIG_APPROVED_FILE_UPLOAD_PATH'],incoming_file2.file_name)).should == true
    #     File.file?(incoming_file2.file.path).should == false
    #   end
    # end
    
    describe "PUT approve" do
      it "(create) unapproved record can be approved" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
        sc_service = Factory(:sc_service, :code => 'ECOL', :name => 'Ecollect')
        inc_file_type = Factory(:incoming_file_type, :sc_service_id => sc_service.id, :code => 'RMTRS', :name => 'Remitters')
        incoming_file = Factory(:incoming_file, :service_name => sc_service.code, :file_type => inc_file_type.code, :approval_status => 'U')
        EcolUnapprovedRecord.count.should == 1
        put :approve, {:id => incoming_file.id}
        EcolUnapprovedRecord.count.should == 0
        incoming_file.reload
        incoming_file.approval_status.should == 'A'
      end
    end

    describe "GET override_records" do
      it "updates the requested incoming_file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:post, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/override?fileName=#{incoming_file.file_name}").
          with(:body => "1,2", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/text', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :override_records, {:file => incoming_file.file_name, :record_ids => [1,2]}
        flash[:alert].should == "Status code: 202 <br> Message: Accepted"
        response.should be_redirect
      end
    end

    describe "GET skip_records" do
      it "updates the requested incoming_file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:post, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/skip_failed_records?fileName=#{incoming_file.file_name}").
          with(:body => "1,2", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'0', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :skip_records, {:id => incoming_file.id}
        flash[:alert].should == nil
        response.should be_redirect
      end
    end

    describe "GET approve_restart" do
      it "updates the requested incoming_file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:post, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/retry_failed_records?fileName=#{incoming_file.file_name}").
          with(:body => "1,2", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'0', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :approve_restart, {:id => incoming_file.id}
        flash[:alert].should == nil
        response.should be_redirect
      end
    end

    describe "GET reject_records" do
      it "updates the requested incoming_file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:put, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/reject?fileName=#{incoming_file.file_name}").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'0', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :reject, {:id => incoming_file.id}
        flash[:alert].should == "Status code: 202 <br> Message: Accepted"
        response.should be_redirect
      end
    end

    describe "GET process_file" do
      it "updates the requested incoming_file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:put, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/retry_file?fileName=#{incoming_file.file_name}").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'0', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :process_file, {:id => incoming_file.id}
        flash[:alert].should == "Status code: 202 <br> Message: Accepted"
        response.should be_redirect
      end
    end

    describe "GET reset" do
      it "updates the requested incoming_file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:post, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/reset_records?fileName=#{incoming_file.file_name}").
          with(:body => "1,2", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'0', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :reset, {:id => incoming_file.id}
        flash[:alert].should == nil
        response.should be_redirect
      end
    end

    describe "GET generate_response_file" do
      it "should generate response file" do
        user_role = UserRole.find_by_user_id(@user.id)
        user_role.delete
        Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
        incoming_file = Factory(:incoming_file, :approval_status => 'A')
        WebMock.stub_request(:put, "#{ENV['CONFIG_URL_IIB_FILE_MGR']}/fm/incoming_files/enqueue_response_file?fileName=#{incoming_file.file_name}").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'0', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 202, :body => "", :headers => {})
        get :generate_response_file, {:id => incoming_file.id}
        flash[:alert].should == "Status code: 202 <br> Message: Accepted"
        response.should be_redirect
      end
    end
  end
end