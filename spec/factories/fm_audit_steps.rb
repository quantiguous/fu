FactoryGirl.define do
  factory :fm_audit_step, class: 'Fu::FmAuditStep'  do
    auditable_id 1
    auditable_type "SuIncomingRecord"
    step_no 1
    attempt_no 1
    status_code "NEW"
    step_name "NEW"
  end
end