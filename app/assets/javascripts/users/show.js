//= require ../post
//= require ../cascading
//= require ../textarea_form
//= require ../flash_message
//= require ../game
//= require ../upload_image
//= require ../../../../vendor/assets/javascripts/jquery.waterwheelCarousel.min

$(document).ready(function() {
  show_level($(".total-level").parent());
  var user_id = $(".avatar-block").attr("user_id");

  // upload_avatar
  qiniu_upload({
    trigger_item: ".upload-avatar-edit-button",
    sonkwo_callback: "updateavatar",
    success: function(url) {
      $(".user-avatar").attr("src", url+"_l");
    }
  });

  var posts = post("/home/posts.json");
  var cascadings = cascading({
    itemSelector: ".item_Container",
    columnWidth: 341,
    posts: posts,
    on_loading: function() {
      $(".post-loading").hide();
    },
    after_fetch: function() {
      $(".post-loading").hide();
    }
  });
  cascadings.start();

  var comments = comment({
    get_success: function() {
      cascadings.refresh();
    }
  });
  posts.bind_like_event(".post-item");
  posts.bind_recommend_event(".post-item", function() {});
  posts.bind_comment_event(".post-item", comments, cascadings.refresh, cascadings.refresh);

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

  function slide_3d() {
    this.initialize.apply(this, arguments);
  }

});
