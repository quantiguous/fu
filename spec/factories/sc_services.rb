FactoryGirl.define do
  factory :sc_service, class: 'Fu::ScService'  do
    sequence(:code) {|n| "#{n}" }
    sequence(:name) {|n| "#{n}" }
  end
end
