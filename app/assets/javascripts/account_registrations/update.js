//= require ../check_form
//= require ../upload_image
//= require ../../../../vendor/assets/javascripts/jquery.form

$(document).ready(function() {
  qiniu_upload({
    item: ".avatar-image",
    sonkwo_callback: "updateavatar"
  });
});
