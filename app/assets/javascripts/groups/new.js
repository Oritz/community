//= require ../upload_image

$(document).ready(function() {
  // upload_avatar
  qiniu_upload({
    trigger_item: ".upload-image-edit-button",
    success: function(url) {
      $(".group-logo").attr("src", url);
      $("[name='group[logo]']").attr("value", url);
    }
  });
});
