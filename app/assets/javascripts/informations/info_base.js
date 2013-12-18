function get_items(options) {
  options = $.extend(true, {
    url: undefined,
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
        var $wrap = $(".information-container").html("");
        var i;
        for(i = 0; i < data.data.length; ++i) {
          var item = data.data[i];
          var $item = $($(".item-hide").html());
          $item.attr("item_id", item.id);
          options.fill_func($item, item);
          if(item.account_id)
            $item.addClass(options.active_class);
          $wrap.append($item);
        }
      }
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
