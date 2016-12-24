# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:file_name) { |n| "file#{n}" }
  factory :incoming_file, class: 'Fu::IncomingFile'  do
    service_name {Factory(:sc_service).code}
    file_type {Factory(:incoming_file_type).code}
    file Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/rails.txt')))
    file_name 
    size_in_bytes 1
    line_count 1
    status "N"
    started_at "2015-06-15"
    ended_at "2015-06-15"
    approval_status 'U'
    last_action 'C'
  end
end
