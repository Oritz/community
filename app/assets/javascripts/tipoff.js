//= require flash_message

$(document).ready(function() {
  $(document).on("click", ".tipoff", function() {
    var $output = $(".tipoff-block").clone();
    var detail_type = $(this).attr("detail_type");
    var detail_id = $(this).attr("detail_id");
    $output.find("[name='detail_type']").attr("value", detail_type);
    $output.find("[name='detail_id']").attr("value", detail_id);
    $output.show();
    // bind events
    $output.on("click", "[name=cancel]", function() {
      $.fancybox.close();
    }).on("change", "[name=tipoff_reason_id]", function() {
      $(this).parents(".tipoff-block").find(".error-container").html("");
    }).on("click", "[name=ok]", function() {
      var $checked = $(this).parents(".tipoff-block").find("input[name=tipoff_reason_id]:checked");
      if($checked.length == 0) {
        $(this).parents(".tipoff-block").find(".error-container").show();
        return;
      }

      var detail_type = $(this).parents(".tipoff-block").find("[name=detail_type]").val();
      var detail_id = $(this).parents(".tipoff-block").find("[name=detail_id]").val();

      $.ajax({
        url: "/tipoffs",
        type: "POST",
        cache: false,
        data: {
          tipoff_reason_id: $checked.val(),
          detail_type: detail_type,
          detail_id: detail_id
        },
        dataType: "json",
        success: function(data) {
          show_message(data);
          if(data.status == "success") {
            Messenger().post("我们已经收到您的举报，我们将会尽快处理");
          }
        },
        error: function() {
          Messenger().post("网络错误");
        }
      }).done(function() {
        $.fancybox.close();
      });
    });
    $.fancybox.open($output, {
      closeBtn: false,
      padding: 0,
      closeClick: false,
      modal: true,
      helpers: {
        title: {
          type: 'outside'
        }
      }
    });
  });
});
