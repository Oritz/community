//= require image

$(document).ready(function() {
  $("form.new_talk").submit(function() {
    $(this).ajaxSubmit({
      url: "/talks.json",
      success: post_success,
      resetForm: true
    });
    return false;
  });

  $("form#qiniu_uploader [name='file']").change(function() {
    if($(this).val() != "")
      $("form#qiniu_uploader").submit();
  });

  $("form.new_talk .post-pic").click(function() {
    var $block = $("#msgBox .image-upload-block");
    $block.toggle();
    $(".image-upload-block .image-upload-result span").hide();
    if($block.is(":visible")) {
      $(".image-upload-block .image-upload-result .image-upload-before").show();
      $(".image-upload-block .image-upload-form file").attr("src", "");
    }
  });

  $(".image-upload-block .image-upload-btn").click(function() {
    $("form#qiniu_uploader [name='file']").click();
  });

  $(".image-upload-block .image-upload-cancel").click(function() {
    $(".image-upload-block .image-upload-result span").hide();
    $(".image-upload-block .image-upload-result .image-upload-before").show();
    $("form#new_talk [name='new_talk[image_url]']").val("");
  });

  $(".image-upload-block .image-upload-reselect").click(function() {
    $("form#qiniu_uploader [name='file']").click();
  });

  $("form#qiniu_uploader").submit(function() {
    // loading
    $(".image-upload-block .image-upload-result span").hide();
    $(".image-upload-block .image-upload-result .image-upload-loading").show();

    $(this).ajaxSubmit({
      success: function(data) {
        $("form.new_talk").find("[name='talk[cloud_storage_id]']").attr("value", data["storage_id"]);
        $(".image-upload-block .image-upload-after img").attr("src", data["dest_url"]+"?imageView/2/w/100");
        $(".image-upload-block .image-upload-result span").hide();
        $(".image-upload-block .image-upload-result .image-upload-after").show();
      },
      error: function(response) {
        Messenger.post("上传图片出错了~");
      }
    });
    return false;
  });
});

function post_success(data, statusText, xhr, $form) {
  var status = data.status;
  if(status == "success") {
    Messenger().post("发布成功");
    $("form.new_talk .post-pic").click();
    $("form.new_talk [name='talk[content]']").attr("value", "");
  }
  else if(status == "error")
    Messenger().post(data.message);
  else {
    $.each(data.data, function(key, value) {
      Messenger().post(key + ":" + value);
    });
  }
}
