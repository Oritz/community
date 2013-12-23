//= require ../misc
$(document).ready(function() {
  function get_items(options) {
    options = $.extend(true, {
      url: undefined,
      container: undefined,
      item: undefined,
      active_class: "active",
      fill_func: function($item, data) {
      }
    }, options);

    if(typeof options.url === "undefined")
      return;

    $.ajax({
      url: options.url,
      cache: false,
      success: function(data) {
        show_message(data);
        if(data.status === "success") {
          var $wrap = $(options.container).html("");
          var i;
          for(i = 0; i < data.data.length; ++i) {
            var item = data.data[i];
            var $item = $($(".hide-items").find(options.item).html());
            $item.attr("item_id", item.id);
            options.fill_func($item, item);
            if(item.account_id)
              $item.addClass(options.active_class);
            $wrap.append($item);
          }
        }
        $(".information-container").hide();
        $wrap.show("normal");
      },
      error: function() {
        Messenger().post("网络错误");
      }
    });
  }

  function item_op(options) {
    options = $.extend(true, {
      url: undefined,
      op: undefined,
      class_active: "active",
      item: undefined
    }, options);

    if(typeof options.url === "undefined")
      return;

    var $item = options.item;
    var op_method;
    if(options.op == "add") {
      op_method = "PUT";
    }
    else if(options.op == "remove") {
      op_method = "DELETE";
    }
    else
      return;
    $.ajax({
      url: options.url,
      data: {_method: op_method},
      dataType: 'json',
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      success: function(data) {
        show_message(data);
        if(data.status === "success") {
          if(options.op === "add")
            $item.addClass(options.class_active);
          else
            $item.removeClass(options.class_active);
        }
      },
      error: function() {
        Messenger().post("网络错误");
      }
    });
  }

  function get_tags() {
    get_items({
      url: "/informations/tags.json",
      container: ".information-tags",
      item: ".tag-item",
      fill_func: function($item, data) {
        $item.find(".font").html(data.name);
        $item.attr("addurl", "/home/tags/"+data.id+".json");
        $item.attr("rmurl", "/home/tags/"+data.id+".json");
      }
    });
  }

  function get_groups()
  {
    get_items({
      url: "/informations/groups.json",
      container: ".information-groups",
      item: ".group-item",
      active_class: "inter",
      fill_func: function($item, data) {
        $item.find(".group-name").html(data.name);
        $item.find(".group-description").html(data.description);
        $item.find(".group-member").html("已有"+data.member_count+"位成员");
        $item.find(".group-image").attr("src", data.logo);
        $item.attr("rmurl", "/groups/"+data.id+"/remove_user.json");
        $item.attr("addurl", "/groups/"+data.id+"/add_user.json");
      }
    });
  }

  function get_friends()
  {
    get_items({
      url: "/informations/friends.json",
      container: ".information-friends",
      item: ".friend-item",
      active_class: "interest",
      fill_func: function($item, data) {
        $item.find(".account-name").html(data.nick_name);
        $item.find(".account-avatar").attr("src", data.avatar);
        $item.find(".account-level").html("Lv "+data.level);
        $item.find(".follower-count").html(data.follower_count);
        $item.find(".following-count").html(data.following_count);
        $item.find(".post-count").html(data.post_count);
        $item.find(".level").attr("level", data.level);
        $item.attr("rmurl", "/users/unfollow.json?target_id="+data.id);
        $item.attr("addurl", "/users/follow.json?target_id="+data.id);
        show_level($item);
      }
    });
  }

  var step = parseInt($(".step").attr("current_step"));
  var steps = [
    function() {
      get_tags();
    },
    function() {
      get_groups();
    },
    function() {
      get_friends();
    }
  ];

  steps[step]();
  $(".push_nav .push_nav_style").eq(step).find("a").removeClass("bjcl_ccc").addClass("bjcl_red");

  $(".refresh-items").click(function() {
    steps[step]();
  });
  $(document).on("click", ".information-container .information-item", function() {
    var active_class = $(this).attr("active_class");
    var addurl = $(this).attr("addurl");
    var rmurl = $(this).attr("rmurl");
    if($(this).hasClass(active_class)) {
      item_op({
        url: rmurl,
        op: "remove",
        class_active: active_class,
        item: $(this)
      });
    }
    else {
      item_op({
        url: addurl,
        op: "add",
        class_active: active_class,
        item: $(this)
      });
    }
  });
});
