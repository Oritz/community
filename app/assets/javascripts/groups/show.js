//= require misc
//= require image
//= require qiniu
//= require textarea_form
//= require template

$(document).ready(function() {
  handle_image_upload();
  var csrf = $('meta[name="csrf-token"]').attr('content');
  textarea_form({
    form_selector: "#new_talk",
    limit_num: 140,
    success: after_success_post
  });

  get_templates({
    success: function(templates) {
      // cascading
      var $wrapper = cascading();
      // forward
      // comment
      // scroll event
      start_scroll(templates, $wrapper, csrf, url);
    }
  });
});
