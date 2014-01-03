//= require ../upload_image

$(document).ready(function() {
  // upload_avatar
  qiniu_upload({
    trigger_item: ".upload-image-edit-button",
    sonkwo_callback: "updategrouplogo",
    success: function(url) {
      $(".user-avatar").attr("src", url+"_l");
    }
  });
});
