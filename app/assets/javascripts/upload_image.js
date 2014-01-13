//= require flash_message

function talk_image_upload(opts) {
  function clean_result() {
    // clean result
    is_uploading = false;
    $show_block.find(".image-upload-result").children().hide();
    $show_block.find(".image-upload-result .image-upload-before").show();
    $block.find(":file").attr("value", "");
    options.close();
  }

  function image_upload($form) {
    $block.one("submit", function() {
      $(this).ajaxSubmit({
        beforeSubmit: function(arr, $form, submitoptions) {
          is_uploading = true;
          $show_block.find(".image-upload-result").children().hide();
          $show_block.find(".image-upload-result .image-upload-loading").show();
        },
        success: function(data) {
          $show_block.find(".image-upload-after img").attr("src", data.dest_url+"?imageView/2/w/100");
          is_uploading = false;
          $show_block.find(".image-upload-result").children().hide();
          $show_block.find(".image-upload-result .image-upload-after").show();
          $block.find(":file").attr("value", "");
          options.success(data);
        },
        error: function(data) {
          clean_result();
          Messenger().post("上传图片出错了");
          options.error();
        }
      });

      return false;
    });

    $form.submit();
  }

  var defaults = {
    block: "#qiniu_uploader_form",
    item: undefined,
    show_block: ".image-upload-block",
    success: function(data) {
    },
    error: function() {
    },
    close: function() {
    }
  };

  var options = $.extend({}, defaults, opts);

  var $block = $(options.block);
  var $btn = $(options.item);
  var $show_block = $(options.show_block);
  var is_uploading = false;
  $btn.click(function() {
    if($show_block.is(":visible")) {
      $show_block.hide();
      clean_result();
    }
    else {
      clean_result();
      $show_block.show();
    }
  });

  $show_block.find(".image-upload-btn").click(function() {
    $block.find(":file").click();
  });

  $block.find(":file").change(function() {
    // submit form
    if($(this).val() != "")
      image_upload($(this).parent());
  });

  $show_block.find(".image-upload-cancel").click(function() {
    clean_result();
  });

  $show_block.find(".image-upload-reselect").click(function() {
    $block.find(":file").click();
  });
}

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
          $block.find(":file").attr("value", "");
        },
        error: function(response) {
          Messenger().post("上传图片出错");
          is_uploading = false;
          $qiniu_item.find(".qiniu-image-upload-original-image").removeClass("image-gray");
          $qiniu_item.find(".qiniu-image-upload-loading").hide();
          $block.find(":file").attr("value", "");
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
    if($(this).val() != "")
      image_upload($(this).parent());
  });
}
