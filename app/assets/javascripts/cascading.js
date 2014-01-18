function cascading(opts) {
  var options = $.extend(true, {
    wrapper: ".posts-container",
    posts: undefined
  }, opts);

  var $wrapper = $(options.wrapper);

  function fetch() {
    options.posts.fetch_posts({
      loading: options.on_loading,
      get_end_id: function() {
        return $wrapper.attr("end_id");
      },
      success: function(data) {
        options.after_fetch();
        if(data.length > 0) {
          var end_id = data[data.length-1].id;
          $wrapper.attr("end_id", end_id);
        }
      },
      error: function() {
        options.after_fetch();
      },
      post_process: function($post) {
        $wrapper.append($post);
      }
    });
  }

  return {
    start: function() {
      $(window).on("scroll", function() {
        if($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
          fetch();
        }
      });

      fetch();
    },
    prepend_item: function(data) {
      var templates = template();
      var $item = templates.post(data);
      if($wrapper) {
        $wrapper.prepend($item).imagesLoaded(function() {
          $wrapper.masonry('prepended', $item, true);
        });
      }
    },
    refresh: function() {
      $wrapper.masonry();
    }
  };
}
