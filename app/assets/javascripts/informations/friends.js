//= require ./info_base
$(document).ready(function() {
  get_items({
    url: "/informations/friends.json",
    active_class: "interest",
    fill_func: function($item, data) {
      $item.find(".account-name").html(data.nick_name);
      $item.find(".account-avatar").attr("src", data.avatar);
      $item.find(".account-level").html("Lv "+data.level);
      $item.find(".follower-count").html(data.follower_count);
      $item.find(".following-count").html(data.following_count);
      $item.find(".post-count").html(data.post_count);
    }
  });

  $(document).on("click", ".information-container .information-item", function() {
    var item_id = $(this).attr("item_id");
    if($(this).hasClass("interest")) {
      item_op({
        url: "/users/unfollow.json?target_id="+item_id,
        op: "remove",
        class_active: "interest",
        item: $(this)
      });
    }
    else {
      item_op({
        url: "/users/follow.json?target_id="+item_id,
        op: "add",
        class_active: "interest",
        item: $(this)
      });
    }
  });

  $(".refresh-items").click(function() {
    get_items({
      url: "/informations/friends.json",
      active_class: "inter",
      fill_func: function($item, data) {
        $item.find(".account-name").html(data.nick_name);
        $item.find(".account-avatar").attr("src", data.avatar);
        $item.find(".account-level").html("Lv "+data.level);
        $item.find(".follower-count").html(data.follower_count);
        $item.find(".following-count").html(data.following_count);
        $item.find(".post-count").html(data.post_count);
      }
    });
  });
});
