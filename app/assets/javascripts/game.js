//= require flash_message

function game_info() {
}

/*
function game_info(options) {
  options = $.extend(true, {
    $wrapper: $("body"),
    success: function(data) {
    },
    error: function(data) {
    }
  }, options);

  $.ajax({
    url: "/users/"+options.user_id+"/games/"+options.game_id+".json",
    cache: false,
    success: function(data) {
      show_message(data);
      if(data.status === "success") {
        data = data.data;
        options.$wrapper.find(".reputation-rank").html(data.rank);
        options.$wrapper.find(".game-achievement-count").html(data.achievements_count);
        options.$wrapper.find(".game-playtime-count").html(data.playtime_forever);
        options.success();
      }
    },
    error: function(data) {
    }
  });

  $.ajax({
    url: "/games/"+options.game_id+"/ranklist.json",
    cache: false,
    success: function(data) {
      show_message(data);
      var $block = options.$wrapper.find(".ranklist-block ul");
      $block.children().each(function() {
        var $target = $(this);
        $target.hide("slow", function() { $target.remove(); });
      });
      if(data.status === "success") {
        data = data.data;
        var i;
        var $item_template = options.$wrapper.find(".ranklist-block .item-template li");
        for(i = 0; i < data.length; ++i) {
          var item = data[i];
          var $item = $item_template.clone();
          $item.find("a").attr("href", "/users/"+item.user_id);
          $item.find("img").attr("alt", item.nick_name).attr("src", item.avatar);
          $item.find(".rank").html((i+1)+suffix(i+1));
          $item.hide();
          $item.appendTo($block).show('slow');
        }
      }
    },
    error: function(data) {
    }
  });
}
*/
