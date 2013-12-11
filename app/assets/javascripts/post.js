//= require misc
//= require image

function posts(options) {
  options = $.extend(true, {
    url: '/home/post.json',
    endid: undefined,
    templates: undefined,
    wrapper: undefined,
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
    status = data.status;
    if(status == "success") {
      if(data.data.length == 0)
        posts.status = 2;
      else
        load_posts(data.data, 0, options.templates, options.wrapper);
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

  function load_posts(items, index, templates, $wrapper) {
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
    $wrapper.append($output).imagesLoaded(function() {
      $wrapper.masonry('appended', $output).masonry();
      show_level($output);
      load_posts(items, index+1, templates, $wrapper);
    });
  }
}

function fetch_posts(templates, $wrapper) {
  var last_id = $wrapper.attr("last_id");
  if(typeof last_id != "undefined") {
    last_id = parseInt(last_id);
    if(last_id <= 0)
      last_id = undefined;
  }
  posts({
    url: '/home/posts.json',
    endid: last_id,
    templates: templates,
    wrapper: $wrapper,
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

$(document).ready(function() {
  $("form.new_talk").submit(function() {
    $(this).ajaxSubmit({
     url: "/talks.json",
      success: post_success,
      resetForm: true
    });
    return false;
  });

  $("form#qiniu_uploader [name='file']").change(function() {
    if($(this).val() != "")
      $("form#qiniu_uploader").submit();
  });

  $("form.new_talk .post-pic").click(function() {
    var $block = $("#msgBox .image-upload-block");
    $block.toggle();
    $(".image-upload-block .image-upload-result span").hide();
    if($block.is(":visible")) {
      $(".image-upload-block .image-upload-result .image-upload-before").show();
      $(".image-upload-block .image-upload-form file").attr("src", "");
    }
  });

  $(".image-upload-block .image-upload-btn").click(function() {
    $("form#qiniu_uploader [name='file']").click();
  });

  $(".image-upload-block .image-upload-cancel").click(function() {
    $(".image-upload-block .image-upload-result span").hide();
    $(".image-upload-block .image-upload-result .image-upload-before").show();
    $("form#new_talk [name='new_talk[image_url]']").val("");
  });

  $(".image-upload-block .image-upload-reselect").click(function() {
    $("form#qiniu_uploader [name='file']").click();
  });

  $("form#qiniu_uploader").submit(function() {
    // loading
    $(".image-upload-block .image-upload-result span").hide();
    $(".image-upload-block .image-upload-result .image-upload-loading").show();

    $(this).ajaxSubmit({
      success: function(data) {
        $("form.new_talk").find("[name='talk[cloud_storage_id]']").attr("value", data["storage_id"]);
        $(".image-upload-block .image-upload-after img").attr("src", data["dest_url"]+"?imageView/2/w/100");
        $(".image-upload-block .image-upload-result span").hide();
        $(".image-upload-block .image-upload-result .image-upload-after").show();
      },
      error: function(response) {
        Messenger.post("上传图片出错了~");
      }
    });
    return false;
  });

  // cascading initialize
  var $wrapper = $("#wrapper").masonry({
    columnWidth: 341,
    itemSelector: ".item_Container"
  });
  var fetch_posts_status = "unfetched";
  $.get('/posts/templates').done(function(data) {
    if(data.status != "success")
      return;
    var templates = data.data;

    // scroll event
    $(window).scroll(function() {
      if($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
        fetch_posts(templates, $wrapper);
      }
    });

    fetch_posts(templates, $wrapper);

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
        creator: {
          id: creator_id,
          nick_name: creator_name
        },
        id: post_id,
        content: content
      }));
      var csrf = $('meta[name="csrf-token"]').attr('content');
      $output.find("[name='authenticity_token']").attr("value", csrf);
      $.fancybox.open($output, {
        closeBtn: false,
        padding: 0,
        closeClick: false,
        modal: true,
        width: 650,
        helpers: {
          title: {
            type: 'outside'
          }
        }
      });
    });
  });
});

function post_success(data, statusText, xhr, $form) {
  var status = data.status;
  if(status == "success") {
    Messenger().post("发布成功");
    $("form.new_talk .post-pic").click();
    $("form.new_talk [name='talk[content]']").attr("value", "");
  }
  else if(status == "error")
    Messenger().post(data.message);
  else {
    $.each(data.data, function(key, value) {
      Messenger().post(key + ":" + value);
    });
  }
}

function recommend_post($form) {
  $form.ajaxSubmit({
    url: "/posts/recommend.json",
    success: function(data, statusText, xhr, $form) {
      if(data.status == "success") {
        Messenger().post("转发成功");
      }
      else if(data.status == "error") {
        Messenger().post(data.message);
      }
      else {
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
    url = "posts/"+post_id+"/like";
    method = "PUT";
  }
  else if(op == "unlike") {
    url = "posts/"+post_id+"/like";
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
      if(data.status == "success") {
        $post.find(".like-count").html(data.data.like_count);
      }
      else if(data.status == "fail")
        Messenger().post(data.data.message);
      else
        Messenger().post(data.message);
    },
    error: function() {
      Messenger().post("网络错误");
    }
  });
}
