//= require template
//= require misc
//= require sonkwo_dialog

function post(url) {
  var status = 0; // 0: available, 1: fetching, 2: unusable
  var templates = template();

  var like_and_unlike_a_post = function($post, op) {
    var post_id = $post.attr("post_id");
    var op_url = "/posts/"+post_id+"/like";
    var method;
    if(typeof post_id === "undefined")
      return;

    if(op === "like")
      method = "PUT";
    else
      method = "DELETE";

    $.ajax({
      url: op_url,
      data: {_method: method},
      dataType: "json",
      type: "POST",
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      success: function(data) {
        show_message(data);
        if(data.status == "success") {
          $post.find(".like-count").html(data.data.like_count);
        }
      },
      error: function() {
        Messenger().post("网络错误");
      }
    });
  };

  return {
    bind_like_event: function(post_item) {
      $(document).on("click", post_item+" .like-op", function() {
        like_and_unlike_a_post($(this).parents(post_item), "like");
      });
    },
    bind_comment_event: function(post_item, comments, show_func, hide_func) {
      $(document).on("click", post_item+" .comment-op", function() {
        var $post = $(this).parents(post_item);
        var $block = $post.find(".comments-block").toggle();
        if($block.is(":visible")) {
          comments.get_comments($post);
          hide_func();
        }
        else {
          $block.find(".comments").html("");
          show_func();
        }
      }).on("click", post_item+" .comments-block .cancel", function() {
        var comment_form = $(this).parents("form");
        comment_form.find("textarea").val("");
        comment_form.find("[name='original_id']").val("").trigger("change");
      }).on("change", post_item+" .comments-block [name=original_id]", function() {
        var comment_id = parseInt($(this).val());
        if(comment_id > 0) {
          var nick_name = $(this).parents(".comments-block").find("[comment_id="+comment_id+"]").attr("nick_name");
          $(this).parent().find(".reply-name").html("回复：" + nick_name);
        }
        else
          $(this).parent().find(".reply-name").html("");
      }).on("click", post_item+" .comments-block .comment-reply", function() {
        var $comment = $(this).parents(".comment-detail");
        var $original = $(this).parents(".comments-block").find("form [name='original_id']");
        $original.val($comment.attr("comment_id")).trigger("change");
        $(this).parents(".post-item").find("textarea").val("");
      }).on("submit", post_item+" .comments-block form", function() {
        comments.post_comment($(this));
        return false;
      });
    },
    bind_recommend_event: function(post_item, success_func) {
      $(document).on("click", post_item+" .recommend-op", function() {
        var $post_item = $(this).parents(post_item);
        var templates = template();
        var data = {
          id: $post_item.attr("post_id"),
          creator_id: $post_item.attr("creator_id"),
          creator_nick_name: $post_item.attr("creator_name"),
          content: $post_item.find(".post-content.post-original").html()
        };
        var $output = templates.recommend(data);
        var dialog = sonkwo_dialog({
          $item: $output
        });
        dialog.open();
        textarea_form({
          form_selector: ".sonkwo-dialog .recommend-form-dialog",
          limit_num: 140,
          success: function(data) {
            show_message(data);
            if(data.status === "success") {
              var templates = template();
              var $item = templates.post(data.data);
              success_func($item);
              show_level($item);
              dialog.close();
            }
          }
        });
      }).on("click", post_item+" .comment-op", function() {
      });
    },
    fetch_posts: function(opts) {
      function load_posts(items, index) {
        if(items.length <= index) {
          status = 0;
          return;
        }
        var item = items[index];
        var $output = templates.post(item);
        options.post_process($output);
        load_posts(items, index+1);
      }

      var defaults = {
        get_end_id: function() {
        },
        loading: function() {
        },
        post_process: function($post) {
        },
        success: function(data) {
        },
        error: function() {
        }
      };

      var options = $.extend({}, defaults, opts);

      if(status != 0)
        return;

      status = 1;
      var end_id = options.get_end_id();
      if(typeof end_id != "undefined") {
        end_id = parseInt(end_id);
        if(end_id <= 0)
          end_id = undefined;
      }

      if(end_id)
        url = url + "?end_id=" + end_id;
      $.ajax({
        url: url,
        cache: false,
        beforeSend: function(data) {
          options.loading();
        },
        success: function(data) {
          if(data.status == "success") {
            if(data.data.length == 0)
              status = 2;
            else {
              load_posts(data.data, 0);
            }
            options.success(data.data);
          }
        },
        error: function(data) {
          status = 2;
          options.error();
        }
      });
    }
  };
}


function comment(opts) {
  var options = opts;
  return {
    get_comments: function($post) {
      var post_id = $post.attr("post_id");
      $.ajax({
        url: "/posts/"+post_id+"/comments.json",
        cache: false,
        success: function(data) {
          show_message(data);
          if(data.status === "success") {
            var templates = template();
            var i;
            for(i = 0; i < data.data.length; ++i) {
              var item = data.data[i];
              var $item = templates.comment(item);
              $post.find(".comments").append($item);
            }
            if(data.data.length > 0)
              options.get_success();
          }
        }
      });
    },
    post_comment: function($form) {
      $form.ajaxSubmit({
        url: $form.attr("action") + ".json",
        context: $form.parents(".post-item"),
        success: function(data, statusText, xhr, $form) {
          show_message(data);
          if(data.status == "success") {
            var templates = template();
            var $item = templates.comment(data.data);
            var comment_line = $form.find(".comment-op .comment-count");
            var comment_count = parseInt(comment_line.html()) + 1;
            comment_line.html(comment_count);
            $form.find(".comments").prepend($item);
            $form.find("[name='original_id']").val("").trigger("change");
            options.get_success();
          }
        },
        clearForm: true
      });
    }
  };
}
