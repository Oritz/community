//= require ../flash_message
//= require ../misc
//= require ../users/user_block

$(document).ready(function() {
  show_level($(".total-level").parent());
  trigger_follow_and_unfollow();
});
