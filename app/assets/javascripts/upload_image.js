//= require flash_message

function qiniu_upload(opts) {
  function image_upload($form) {
    $(options.block).one("submit", function() {
      $(this).ajaxSubmit({
        beforeSubmit: function(arr, $form, submitoptions) {
          // add loading gif here
          // disable trigger_item click
          is_uploading = true;
          $qiniu_item.find(".qiniu-upload-image-edit-button").hide();
          $qiniu_item.find(".qiniu-image-upload-original-image").addClass("image-gray");
          $qiniu_item.find(".qiniu-image-upload-loading").show();
        },
        success: function(data) {
          if(data.status == "error" || data.status == "fail")
            show_message(data);
          else
          {
            $qiniu_item.find(".qiniu-image-upload-original-image").attr("src", data.dest_url+options.suffix);
            options.success(data.dest_url);
          }
          is_uploading = false;
          $qiniu_item.find(".qiniu-image-upload-original-image").removeClass("image-gray");
          $qiniu_item.find(".qiniu-image-upload-loading").hide();
        },
        error: function(response) {
          Messenger().post("上传图片出错");
          is_uploading = false;
          $qiniu_item.find(".qiniu-image-upload-original-image").removeClass("image-gray");
          $qiniu_item.find(".qiniu-image-upload-loading").hide();
        }
      });
      return false;
    });

    $form.submit();
  }

  var is_uploading = false;
  var defaults = {
    block: "#qiniu_uploader_form",
    item: undefined,
    edit_text: "上传图片",
    suffix: "",
    sonkwo_callback: "",
    success: function(image_url) {
    }
  };

  var options = $.extend({}, defaults, opts);

  var $item = $(options.item);
  var $qiniu_item = $("<div class='qiniu-image-upload'><span class='qiniu-image-upload-loading'><img src='/loading.gif' /></span><span class='qiniu-upload-image-edit-button'>"+options.edit_text+"</span></div>");
  $qiniu_item.prepend($item.clone().addClass("image-light qiniu-image-upload-original-image"));
  $item.replaceWith($qiniu_item);
  var $edit_button = $qiniu_item.find(".qiniu-upload-image-edit-button");

  $qiniu_item.on({
    mouseenter: function() {
      if(!is_uploading)
        $edit_button.show();
    },
    mouseleave: function() {
      if(!is_uploading)
        $edit_button.hide();
    }
  });

  $(options.block).find("[name='x:sonkwo_callback']").attr("value", options.sonkwo_callback);
  var $file_input = $(options.block).find(":file");
  var $btn = $(options.block).find(":submit");
  $edit_button.on("click", function() {
    if(!is_uploading)
      $file_input.click();
  });

  $file_input.change(function() {
    image_upload($(this).parent());
  });
}
