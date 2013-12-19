//= require ./info_base

$(document).ready(function() {
  get_items({
    url: "/informations/tags.json",
    fill_func: function($item, data) {
      $item.find(".font").html(data.name);
    }
  });

  $(document).on("click", ".information-container .information-item", function() {
    var item_id = $(this).attr("item_id");
    if($(this).hasClass("active")) {
      item_op({
        url: "/home/tags/"+item_id+".json",
        op: "remove",
        class_active: "active",
        item: $(this)
      });
    }
    else {
      item_op({
        url: "/home/tags/"+item_id+".json",
        op: "add",
        class_active: "active",
        item: $(this)
      });
    }
  });

  $(".refresh-items").click(function() {
    get_items({
      url: "/informations/tags.json",
      fill_func: function($item, data) {
        $item.find(".font").html(data.name);
      }
    });
  });
});
