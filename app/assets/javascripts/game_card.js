//= require flash_message
//= require ../../../vendor/assets/javascripts/slidr.js

function game_card(opts) {
  var options = $.extend(true, {
    block: undefined
  }, opts);

  var $block = $(options.block);
  var game_id = $block.attr("game_id");
  var status = 0; // 0 for available, 1 for loading, 2 for others

  var xhr;

  return {
    get_user_data: function(user_id, success_func) {
      if(status != 0)
        return;
      status = 1;
      xhr = $.ajax({
        url: "/users/"+user_id+"/games/"+game_id+".json",
        cache: false,
        beforeSend: function() {
          // clear data
          $block.find(".reputation-rank").html("");
          $block.find(".delta-reputation").html("暂时没有军阶信息");
          $block.find(".user-game-trophy").html("N/A");
          $block.find(".user-game-time").html("N/A");
          $block.find(".rank-list").html("");
          $block.find(".SK-game-card-loading").show();
        },
        success: function(data) {
          show_message(data);
          $block.find(".SK-game-card-loading").hide();
          $block.find(".user-game-info").show();
          if(data.status === "success") {
            var len = data.data.length;
            $block.find(".reputation-rank").html(data.data.rank);
            if(data.data.rank == "未排名")
              $block.find(".delta-reputation").html("暂时没有军阶信息");
            else
              $block.find(".delta-reputation").html("您还需要"+data.data.delta_reputation+"个小时或成就才能达到下一军阶");

            $block.find(".user-game-trophy").html(data.data.achievements_count);
            $block.find(".user-game-time").html(data.data.playtime_forever);
            var i;
            var $rank_block = $block.find(".rank-list");
            for(i = 0; i < data.data.ranklists.length; ++i) {
              var item = data.data.ranklists[i];
              var $item = $("<li><a href=''><img src='' width='50px' /></a></li>");
              $item.find("a").attr("href", "/users/"+item.user_id);
              $item.find("img").attr("alt", item.nick_name).attr("src", item.avatar);
              $item.find(".rank").html((i+1)+suffix(i+1));
              $item.hide();
              $item.appendTo($rank_block).show('slow');
            }

            status = 0;
            success_func();
          }
        },
        error: function(data) {
          Messenger().post("网络错误");
        }
      });
    }
  };
}
