//= require ../flash_message
//= require ../misc

$(document).ready(function() {
  show_level($(".total-level").parent());

  $(".follow-user").click(function() {
    var user_id = $(this).parents(".user-item").attr("user_id");
    var $item = $(this);
    $.ajax({
      url: "/users/follow?target_id="+user_id,
      cache: false,
      type: 'POST',
      dataType: 'json',
      data: {_method: 'PUT'},
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      success: function(data) {
        show_message(data);
        if(data.status == "success") {
          $item.parent().children().toggle();
        }
      }
    });
  });
});
