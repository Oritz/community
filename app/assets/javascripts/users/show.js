//= require ../post
//= require ../cascading
//= require ../textarea_form
//= require ../flash_message
//= require ../game_card
//= require ../upload_image
//= require ../../../../vendor/assets/javascripts/jquery.waterwheelCarousel.min

$(document).ready(function() {
  var posts = post("/users/"+$CONFIG.user_id+"/posts.json");
  var cascadings = cascading({
    wrappger: ".posts-container",
    posts: posts,
    on_loading: function() {
      $(".post-loading").hide();
    },
    after_fetch: function() {
      $(".post-loading").hide();
    }
  });
  cascadings.start();

  var gcs = $(".game-cards .SK-game-card");
  if(gcs.length > 0) {
    var game_cards = [];
    var st = setTimeout(function() {
      var gc_first = game_card({ block: gcs[0] });
      game_cards[0] = gc_first;
      gc_first.get_user_data($CONFIG.user_id, function() {});
    }, 0);

    slidr.create('slidr-div', {
      before: function(e) {
        var in_i = parseInt(e.in.slidr);
        var gc_in = game_cards[in_i];
        if(typeof gc_in === "undefined") {
          gc_in =game_card({
            block: e.in.el
          });
          game_cards[in_i] = gc_in;
        }
        if(typeof st != "undefined")
          clearTimeout(st);
        st = setTimeout(function() {
          gc_in.get_user_data($CONFIG.user_id, function() {});
        }, 1000);
      }
    }).start();
  }
  /*
  // get games
  $.ajax({
    url: "/users/"+$CONFIG.user_id+"/games.json",
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
          $(".games-block .slide_games").append("<img src='"+data.data[i].image+"' alt='"+data.data[i].name+"' game_id="+data.data[i].id+">");
        }

        var $block = $("#focus_Box");
        imagesLoaded($block, function() {
          var fetch_game_info = function($item) {
            setTimeout(function() {
              if($centerItem != $item)
                return;
              var user_id = $(".avatar-block").attr("user_id");
              var game_id =$item.attr("game_id");
              game_info({
                user_id: user_id,
                game_id: game_id
              });
            }, 1000);
          };

          var $centerItem;
          var waterwheel = $("#focus_Box .slide_games").waterwheelCarousel({
            forcedImageWidth: 0,
            separation: 50,
            flankingItems: 1,
            movedToCenter: function($newCenterItem) {
              // get ranklist
              $centerItem = $newCenterItem;
              fetch_game_info($newCenterItem);
            }
          });

          var $images = $("#focus_Box .slide_games").children();
          if($images.length > 0) {
            $centerItem = $images.eq(0);
            fetch_game_info($centerItem);
          }
        });
      }
    },
    error: function() {
      show_message("unknow");
    }
  });
   */
});
