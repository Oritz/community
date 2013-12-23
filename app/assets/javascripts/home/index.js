//= require ../post

$(document).ready(function() {
  show_level($(".total-level").parent());
  start_posts("/home/posts.json");
  
  bind_textarea_limit($('#talk_content'), $('.countTxt_block'), $('#post_submit'), 140);
});
