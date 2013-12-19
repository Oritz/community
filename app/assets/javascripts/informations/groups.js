//= require ./info_base
$(document).ready(function() {
  get_items({
    url: "/informations/groups.json",
    active_class: "inter",
    fill_func: function($item, data) {
      $item.find(".group-name").html(data.name);
      $item.find(".group-description").html(data.description);
      $item.find(".group-member").html("已有"+data.member_count+"位成员");
    }
  });

  $(document).on("click", ".information-container .information-item", function() {
    var item_id = $(this).attr("item_id");
    if($(this).hasClass("inter")) {
      item_op({
        url: "/groups/"+item_id+"/remove_user.json",
        op: "remove",
        class_active: "inter",
        item: $(this)
      });
    }
    else {
      item_op({
        url: "/groups/"+item_id+"/add_user.json",
        op: "add",
        class_active: "inter",
        item: $(this)
      });
    }
  });

  $(".refresh-items").click(function() {
    get_items({
      url: "/informations/groups.json",
      active_class: "inter",
      fill_func: function($item, data) {
        $item.find(".group-name").html(data.name);
        $item.find(".group-description").html(data.description);
        $item.find(".group-member").html("已有"+data.member_count+"位成员");
      }
    });
  });
});
