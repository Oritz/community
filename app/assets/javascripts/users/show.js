//= require ../post
//= require ../flash_message
//= require ../../../../vendor/assets/javascripts/jquery.waterwheelCarousel.min

$(document).ready(function() {
  show_level($(".total-level").parent());
  var user_id = $(".avatar-block").attr("user_id");

  // fetch posts
  start_posts("/users/"+user_id+"/posts.json");

  // get games
  $.ajax({
    url: "/users/"+user_id+"/games.json",
    cache: false,
    success: function(data) {
      show_message(data);
      if(data.status == "success") {
        var len = data.data.length;
        if(len > 0)
          $(".games-block").show();
        else
          $(".games-block").hide();
        var i;
        for(i = 0; i < len; ++i) {
          $(".games-block .slide_games").append("<img src='"+data.data[i].image+"' alt='"+data.data[i].name+"'>");
        }

        $("#focus_Box .slide_games").waterwheelCarousel({
          forcedImageWidth: 0,
          separation: 50,
          flankingItems: 1,
          movingToCenter: function() {
            // get ranklist
          }
        });
      }
    },
    error: function() {
      show_message("unknow");
    }
  });

  function slide_3d() {
    this.initialize.apply(this, arguments);
  }

});
