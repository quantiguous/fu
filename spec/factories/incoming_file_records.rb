# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incoming_file_record, class: 'Fu::IncomingFileRecord'  do
    sequence(:incoming_file_id) { |n| "{n}" }
    sequence(:record_no) { |n| "{n}" }
    record_txt "MyText"
    status "FAILED"
    fault_code "MyString"
    fault_reason "MyString"
  end
end
