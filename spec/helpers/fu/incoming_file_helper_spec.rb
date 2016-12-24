require 'spec_helper'

module Fu
  describe IncomingFileHelper do
    
    context "find_incoming_files" do 
      it "should return incoming files" do
        file_type = Factory(:incoming_file_type, :code => '1234')
        incoming_file = Factory(:incoming_file, :file_type => '1234',:approval_status => 'A')
        find_incoming_files({:file_type => "1234"}).should == [incoming_file]
        find_incoming_files({:file_type=> "CUST01"}).should == [] 

        incoming_file = Factory(:incoming_file, :file_name => 'Process Type',:approval_status => 'A')
        find_incoming_files({:file_name => "process"}).should == [incoming_file]
        find_incoming_files({:file_name => "CUST01"}).should == [] 
      end
    end
  end
end
