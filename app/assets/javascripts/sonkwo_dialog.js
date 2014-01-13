function sonkwo_dialog(opts) {
  opts = $.extend(true, {
    $item: undefined,
    submit: function() {
    }
  }, opts);

  bind_events();

  function bind_events() {
    opts.$item.find(".sonkwo-dialog-closebtn").on("click", function() {
      $.fancybox.close();
    });
    opts.$item.find(".sonkwo-dialog-cancel").on("click", function() {
      $.fancybox.close();
    });
    opts.$item.find(".sonkwo-dialog-submit").on("click", function() {
      opts.submit();
    });
  }

  return {
    open: function() {
      $.fancybox(opts.$item, {
        closeBtn: false,
        padding: 0,
        closeClick: false,
        modal: true,
        wrapCSS: "sonkwo-dialog",
        helpers: {
          title: {
            type: 'outside'
          }
        }
      });
    },
    close: function() {
      $.fancybox.close();
    }
  };
}
