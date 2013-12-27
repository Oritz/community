//= require ../post
$(document).ready(function() {
  show_level($(".total-level").parent());
  start_posts("/home/posts.json");
});
