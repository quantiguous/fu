.form-horizontal.show_form
  .form-main-with-color{:style=>'background-color: #F1F2F8;  height:630px;'}
    %h3 <%= name.camelize %> Incoming File
    %br
    %p{:style => 'text-align:left; padding-left:6px; padding-bottom:17px;'}
    %table.table.no-border{:style=>"table-layout: fixed; width: 100%;"}
      %tr
        %td.label File name
        %td.value
          = @summary.try(:file_name)