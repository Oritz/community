function get_templates(options) {
  options = $.extend(true, {
    success: function(templates) {
    }
  }, options);

  $.get('/posts/templates').done(function(data) {
    if(data.status != "success")
      return;
    var templates = data.data;
    options.success(templates);
  });
}
