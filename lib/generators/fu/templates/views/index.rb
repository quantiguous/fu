%br
%h1 <%= name.camelize %> Incoming Records
%h4
  %br
  &nbsp;
  %br
  = "Total Count: #{@records_count}"
%br
= will_paginate @records

= simple_form_for :<%= name %>_incoming_record, :url => override_records_path, :html => { :method => :get, :class => 'form-horizontal', :autocomplete=>"off", :id => 'update_records', :style=> 'overflow: auto;'} do |f| 
  %table.table.table-bordered.table-striped.table-hover{:style => 'width:100%; border:1px'}
    .thead
      %tr
        %th{:style=>'text-align:left; font-size:12px; background-color: lightblue;'}
        %th{:style=>'text-align:left; background-color: lightblue;'}
          = check_box_tag(:select_all, value = "1", checked = false, options = {})
        %th{:style=>'text-align:left; font-size:12px; background-color: lightblue;'}
          File Name
        %th{:style=>'text-align:left; font-size:12px; background-color: lightblue;'}
          Attempt No
        %th{:style=>'text-align:left; font-size:12px; background-color: lightblue;'}
          Status
        %th{:style=>'text-align:left; font-size:12px; background-color: lightblue;'}
          Fault Text
        %th{:style=>'text-align:left; font-size:12px; background-color: lightblue;'}
          Fault Bitstream
    .tbody
      - @records.each do |record|
        %tr
          %td{:style=>'text-align:left;'}
            = link_to "show", record
          %td{:style=>'text-align:left;'}
            - if can_select?(record)
              = check_box_tag "record_ids[]", record.incoming_file_record_id, false, class: 'txn_select'
          %td{:style=>'text-align:left;'}
            = record.file_name
          %td{:style=>'text-align:left;'}
            = record.incoming_file_record.attempt_no
          %td{:style=>'text-align:left;'}
            = record.incoming_file_record.status
          %td{:style=>'text-align:left;'}
            - if record.incoming_file_record.fault_code.nil?
              - link_text = "Show Fault Text"
            - else 
              - link_text = record.incoming_file_record.fault_code
            = link_to link_text, fu.show_modal_incoming_file_record_path(record.incoming_file_record.id, :flag => 'fault'),  {:remote => true, 'data-toggle' =>  "modal", 'data-target' => '#modal-window'}
          %td{:style=>'text-align:left;'}
            = link_to 'Show Fault Bitstream', fu.show_modal_bitstream_incoming_file_record_path(record.incoming_file_record.id), :flag => 'fault_bitstream'),  {:remote => true, 'data-toggle' =>  "modal", 'data-target' => '#modal-window'}
  .form-actions{:style=>"text-align: center;"}
    = hidden_field_tag :file, params[:file_name]
    - if !@incoming_file.nil? and @incoming_file.try(:pending_approval) == 'Y'
      - can_override = (can? :override_records, IncomingFile)
      - can_skip = (can? :skip_records, IncomingFile)
      - can_retry = (can? :approve_restart, IncomingFile)
      - can_reset = (can? :reset, IncomingFile)
      = render :partial => "incoming_records/api_buttons", :locals => {:status => params[:status], :can_override => can_override, :can_skip => can_skip, :can_retry => can_retry, :can_reset => can_reset, :file_can_override => @incoming_file.incoming_file_type.try(:can_override), :file_can_skip => @incoming_file.incoming_file_type.try(:can_skip), :file_can_retry => @incoming_file.incoming_file_type.try(:can_retry)}

%div{ id:"modal-window", class:"modal hide fade", role: "dialog", 'aria-labelledby' => "myModalLabel", 'aria-hidden' => "true"}