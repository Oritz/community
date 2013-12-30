//= require ../flash_message
//= require ../misc

function trigger_follow_and_unfollow() {
  $(".unfollow-user").click(function() {
    var user_id = $(this).parents(".user-item").attr("user_id");
    var $item  = $(this);
    $.ajax({
      url: "/users/unfollow?target_id="+user_id,
      cache: false,
      type: 'POST',
      dataType: 'json',
      data: {_method: 'DELETE'},
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

  $(".follow-user").click(function() {
    var user_id = $(this).parents(".user-item").attr("user_id");
    var $item  = $(this);
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
}
