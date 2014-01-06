//= require flash_message

function qiniu_upload(opts) {
  function image_upload($form) {
    $(options.block).one("submit", function() {
      $(this).ajaxSubmit({
        beforeSubmit: function(arr, $form, submitoptions) {
          // add loading gif here
        },
        success: function(data) {
          if(data.status == "error" || data.status == "fail")
            show_message(data);
          else
            options.success(data.dest_url);
        },
        error: function(response) {
          Messenger().post("上传图片出错");
        }
      });
      return false;
    });

    $form.submit();
  }

  var defaults = {
    block: "#qiniu_uploader_form",
    trigger_item: undefined,
    sonkwo_callback: "",
    success: function(image_url) {
    }
  };

  var options = $.extend({}, defaults, opts);

  $(options.block).find("[name='x:sonkwo_callback']").attr("value", options.sonkwo_callback);
  var $file_input = $(options.block).find(":file");
  var $btn = $(options.block).find(":submit");
  $(options.trigger_item).click(function() {
    $file_input.click();
  });

  $file_input.change(function() {
    image_upload($(this).parent());
  });
}
