$(document).ready(function(){
  $('h2.fu-collapsible').click(function(){
    $(this).siblings('.fu-collapsible-content').toggle();
  });

  $(".fu-reset-btn").on('click', function(){
    $(".fu-form-horizontal").find("input[type=text], select, input[type=number]").val("");
  });
});