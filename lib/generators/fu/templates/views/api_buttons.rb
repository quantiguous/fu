= can_skip
= file_can_skip
- if (status == "FAILED") && (can_override == true || can_skip == true || can_retry == true)
  = file_can_retry
  - if file_can_override == 'Y'
    = button_tag "Override", :id => 'submit_override', :role => "button", :class => "btn btn-primary"
  - if file_can_skip == 'Y'
    = button_tag "Skip", :id => 'submit_skip', :role => "button", :class => "btn btn-primary"
  - if file_can_retry == 'Y'
    = button_tag "Retry", :id => 'submit_restart', :role => "button", :class => "btn btn-primary"

- if (status == "SKIPPED" || status == "OVERRIDEN" || status == "PENDING RETRY") && (can_reset == true)
  = button_tag "Reset", :id => 'submit_reset', :role => "button", :class => "btn btn-primary"
