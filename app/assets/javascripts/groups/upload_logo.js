//= require ../upload_image

$(document).ready(function() {
  qiniu_upload({
    item: ".group-logo",
    suffix: "_l",
    success: function(url) {
      $("[name='group[logo]'").attr("value", url);
    }
  });
});
