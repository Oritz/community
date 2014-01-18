//= require ../upload_image
//= require ../textarea_form
//= require ../template
//= require ../post
//= require ../cascading
//= require ../vendor/modernizr.custom.17475
//= require ../vendor/jquery.elastislide

$(document).ready(function() {
  show_level($(".total-level").parent());

  // Post
  var posts = post("/home/posts.json");

  // cascading
  var cascadings = cascading({
    itemSelector: ".item_Container",
    columnWidth: 341,
    posts: posts,
    on_loading: function() {
      $(".post-loading").show();
    },
    after_fetch: function() {
      $(".post-loading").hide();
    }
  });

  cascadings.start();

  var comments = comment({
    get_success: function() {
      cascadings.refresh();
    }
  });

  // bind events
  posts.bind_like_event(".post-item");
  posts.bind_recommend_event(".post-item", cascadings.prepend_item);
  posts.bind_comment_event(".post-item", comments, cascadings.refresh, cascadings.refresh);

  // upload image
  talk_image_upload({
    item: ".post-pic",
    success: function(data) {
      $("form #post_cloud_storage_id").attr("value", data.storage_id);
    },
    error: function() {
      $("form #post_cloud_storage_id").attr("value", "");
    },
    close: function() {
      $("form #post_cloud_storage_id").attr("value", "");
    }
  });

  // textarea_form
  textarea_form({
    form_selector: "#new_post",
    limit_num: 140,
    reset: true,
    success: function(data) {
      show_message(data);
      var status = data.status;
      if(status == "success") {
        Messenger().post("发表成功");
        cascadings.prepend_item(data.data);
      }
      // clean pic block
      $(".image-upload-block").hide();
    },
    error: function(data) {
      Messenger().post("网络错误");
      $(".image-upload-block").hide();
    }
  });
});


(function () {
   // slider
  var current = 0,
    //$preview = $('#preview'),
    $carouselEl = $('#carousel'),
    $carouselItems = $carouselEl.children(),
    carousel = $carouselEl.elastislide( {
      current : current,
      minItems : 6,
      onClick : function( el, pos, evt ) {
        changeImage(el, pos);
        evt.preventDefault();
      },
      onReady : function() {
        changeImage( $carouselItems.eq( current ), current );
      }
    });

  function changeImage( el, pos ) {
    //$preview.attr( 'src', el.data( 'preview' ) );
    $carouselItems.removeClass( 'current-img' );
    el.addClass( 'current-img' );
    if (typeof carousel.setCurrent !== 'undefined') {
      carousel.setCurrent( pos );
    }
  }  
})();


