//= require ../post

$(document).ready(function() {
  var user_id = $(".avatar-block").attr("user_id");
  start_posts("/users/"+user_id+"/posts.json");
});
