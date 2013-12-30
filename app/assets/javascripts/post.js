//= require misc
//= require image
//= require qiniu
//= require textarea_form

function posts(options) {
  options = $.extend(true, {
    url: undefined,
    endid: undefined,
    templates: undefined,
    wrapper: undefined,
    csrf: undefined,
    success: function(data) {
    },
    error: function() {
    },
    loading: function() {
    }
  }, options);

  if(typeof posts.status == "undefined")
    // 0: free to usage, 1: fetching, 2: unusable
    posts.status = 0;

  if(posts.status != 0)
    return;

  if(typeof options.templates == "undefined" || typeof options.wrapper == "undefined")
    return;

  if(typeof options.endid != "undefined")
    $.extend(options, {url: options.url = options.url + "?end_id=" + options.endid});

  posts.status = 1;
  options.loading();

  $.ajax({
    url: options.url,
    cache: false
  }).done(function(data) {
    var status = data.status;
    if(status == "success") {
      if(data.data.length == 0)
        posts.status = 2;
      else
        load_posts(data.data, 0, options.templates, options.wrapper, options.csrf);
      options.success(data.data);
      
    }
    else {
      posts.status = 2;
      options.error(data.data);
    }
  }).fail(function() {
    posts.status = 2;
    options.error();
  });

  function load_posts(items, index, templates, $wrapper, csrf) {
    if(items.length <= index) {
      posts.status = 0;
      return;
    }

    var post = items[index];
    var template = templates.talk;
    if(post.detail_type == "Talk")
      template = templates.talk;
    else if(post.detail_type == "Subject")
      template = templates.subject;
    else
      template = templates.recommend;
    var $output = $(Mustache.render(template, post));
    $output.find(".comments-block form [name='authenticity_token']").attr("value", csrf);
    $wrapper.append($output).imagesLoaded(function() {
      $wrapper.masonry('appended', $output).masonry();
      show_level($output);
      load_posts(items, index+1, templates, $wrapper, csrf);
    });
  }
}

function fetch_posts(templates, $wrapper, csrf, url) {
  var last_id = $wrapper.attr("last_id");
  if(typeof last_id != "undefined") {
    last_id = parseInt(last_id);
    if(last_id <= 0)
      last_id = undefined;
  }
  posts({
    url: url,
    endid: last_id,
    templates: templates,
    wrapper: $wrapper,
    csrf: csrf,
    success: function(data) {
      $(".post-loading").hide();
      if(data.length > 0) {
        last_id = data[data.length-1].id;
        $wrapper.attr("last_id", last_id);
      }
    },
    error: function() {
      $(".post-loading").hide();
      Messenger().post("出错了");
    },
    loading: function() {
      $(".post-loading").show();
    }
  });
}

function start_posts(url) {
  // cascading initialize
  var $wrapper = $("#wrapper").masonry({
    columnWidth: 341,
    itemSelector: ".item_Container"
  });

  handle_image_upload();

  var csrf = $('meta[name="csrf-token"]').attr('content');
  var fetch_posts_status = "unfetched";
  $.get('/posts/templates').done(function(data) {
    if(data.status != "success")
      return;
    var templates = data.data;
    function after_success_post(data) {
      show_message(data);
      var status = data.status;
      if(status == "success") {
        $(".image-upload-block").hide();
        $("form.new_talk [name='talk[content]']").attr("value", "");
        add_post_to_wrapper(templates.talk, data.data, $wrapper);
      }
    }

    textarea_form({
      form_selector: "#new_talk",
      limit_num: 140,
      success: after_success_post,
    });
    // new_talk form
    /*
    $("form.new_talk").submit(function() {
      var that = this;
      if ($(this).find('input[name="commit"]').attr('disable') !== '') {
        $(this).ajaxSubmit({
          url: "/talks.json",
          beforeSend: function() {
            // check form
            var content = $.trim($(that).find("#talk_content").val());
            if(content.length > 140) {
              Messenger().post("字数超过限制了");
              return false;
            }
            else if(content == "")
              return false;
            else
              return true;
          },
          success: function(data) {
            show_message(data);
            var status = data.status;
            if(status == "success") {
              $("form.new_talk .post-pic").click();
              $("form.new_talk [name='talk[content]']").attr("value", "");
              add_post_to_wrapper(templates.talk, data.data, $wrapper);
            }
          },
          resetForm: true
        });
      }
      return false;
    });
    */
   
    // scroll event
    $(window).scroll(function() {
      if($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
        fetch_posts(templates, $wrapper, csrf, url);
      }
    });

    fetch_posts(templates, $wrapper, csrf, url);

    // bind close btn on popbox
    $(document).on("click", ".pop-box .pop-box-closebtn", function() {
      $.fancybox.close();
    }).on("click", ".pop-box .cancelBtn", function() {
      $.fancybox.close();
    }).on("submit", ".pop-box form", function() {
      recommend_post($(this), templates, $wrapper);
      return false;
    });

    // post operations
    $(document).on("click", ".post-item .like-op", function() {
      like_or_unlike_post($(this).parents(".post-item"), "like");
    }).on("click", ".post-item .recommend-op", function() {
      $item = $(this).parents(".post-item");
      var post_id = $item.attr("post_id");
      var creator_id = $item.attr("creator_id");
      var creator_name = $item.attr("creator_name");
      var content = $item.find(".post-content").html();
      if(typeof($item.attr("original_post_id")) != "undefined") {
        post_id = $item.attr("original_post_id");
        creator_id = $item.attr("original_creator_id");
        creator_name = $item.attr("original_creator_name");
      }

      var $output = $(Mustache.render(templates.recommend_pop, {
        creator_id: creator_id,
        creator_nick_name: creator_name,
        id: post_id,
        content: content
      }));
      $output.find("[name='authenticity_token']").attr("value", csrf);
      $.fancybox.open($output, {
        closeBtn: false,
        padding: 0,
        closeClick: false,
        modal: true,
        helpers: {
          title: {
            type: 'outside'
          }
        }
      });
    });

    // comment
    $(document).on("click", ".post-item .comment-op", function() {
      var $block = $(this).parents(".post-item").find(".comments-block").toggle();
      $wrapper.masonry();
      if($block.is(":visible"))
        fetch_comments(templates.comment, $block.find(".comments"), $wrapper);
      else
        $block.find(".comments").html("");
    }).on("submit", ".post-item .comments-block form", function() {
      $(this).ajaxSubmit({
        url: $(this).attr("action") + ".json",
        context: $(this).parents(".post-item"),
        success: function(data, statusText, xhr, $form) {
          show_message(data);
          if(data.status == "success") {
            var $item = $(Mustache.render(templates.comment, data.data));
            console.log($item.html());
            var comment_line = $(this).find(".comment-op .comment-count");
            var comment_count = parseInt(comment_line.html()) + 1;
            comment_line.html(comment_count);
            $(this).find(".comments").prepend($item);
            $(this).find("[name='original_id']").val("").trigger("change");
            $wrapper.masonry();
          }
        },
        clearForm: true
      });
      return false;
    }).on("click", ".post-item .comments-block .comments .comment-reply", function() {
      var $comment = $(this).parents(".comment-detail");
      var $original = $(this).parents(".comments-block").find("form [name='original_id']");
      $original.val($comment.attr("comment_id")).trigger("change");
      $(this).parents(".post-item").find("textarea").val("");
    }).on("change", ".post-item .comments-block form [name='original_id']", function() {
      var comment_id = parseInt($(this).val());
      if(comment_id > 0) {
        var nick_name = $(this).parents(".comments-block").find("[comment_id="+comment_id+"]").attr("nick_name");
        $(this).parent().find(".reply-name").html("回复：" + nick_name);
      }
      else
        $(this).parent().find(".reply-name").html("");
    }).on("click", ".post-item .comments-block form .cancel", function() {
      var comment_form = $(this).parents("form");
      comment_form.find("textarea").val("");
      comment_form.find("[name='original_id']").val("").trigger("change");
    });
  });
}

function fetch_comments(template, $block, $wrapper) {
  var post_id = $block.parents(".post-item").attr("post_id");
  $.ajax({
    url: "/posts/"+post_id+"/comments.json",
    cache: false,
    success: function(data) {
      show_message(data);
      if(data.status == "success") {
        var i = 0;
        for(i = 0; i < data.data.length; ++i) {
          var item = data.data[i];
          var $item = $(Mustache.render(template, item));
          $block.append($item);
        }
        $wrapper.masonry();
      }
    }
  });
}

function add_post_to_wrapper(template, data, $wrapper) {
  var $output = $(Mustache.render(template, data));
  show_level($output);
  $wrapper.prepend($output).imagesLoaded(function() {
    $wrapper.masonry('prepended', $output, true);
  });
}

function recommend_post($form, templates, $wrapper) {
  $form.ajaxSubmit({
    url: $form.attr("action") + ".json",
    success: function(data, statusText, xhr, $form) {
      show_message(data);
      if(data.status == "success") {
        add_post_to_wrapper(templates.recommend, data.data, $wrapper);
        $.fancybox.close();
      }
    }
  });
}

function like_or_unlike_post($post, op) {
  var post_id = $post.attr("post_id");
  if(typeof post_id == "undefined")
    return;
  var url = "";
  var method = "";
  if(op == "like") {
    url = "/posts/"+post_id+"/like";
    method = "PUT";
  }
  else if(op == "unlike") {
    url = "/posts/"+post_id+"/like";
    method = "DELETE";
  }
  else
    return;
  $.ajax({
    url: url,
    data: {_method: method},
    dataType: 'json',
    type: 'POST',
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
}
