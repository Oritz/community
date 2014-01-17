//= require misc

function template() {
  return {
    post: function(data) {
      var $t = $($(".templates .post-template").html());
      $t.attr("post_id", data.id).attr("creator_id", data.creator_id).attr("creator_name", data.creator_nick_name);
      $t.find(".creator-name").html(data.creator_nick_name);
      $t.find(".creator-link").attr("href", "/users/"+data.id);
      $t.find(".creator-level").html("Lv "+data.creator_level);
      $t.find(".like-count").html(data.like_count);
      $t.find(".recommend-count").html(data.recommend_count);
      $t.find(".comment-count").html(data.comment_count);
      $t.find(".post-time").html(data.created_at);
      $t.find(".creator-avatar").attr("src", data.creator_avatar);
      $t.find(".level").attr("level", data.creator_level);
      $t.find(".post-content").html(data.content);
      if(data.image_url)
        $t.find(".post-image").attr("src", data.image_url);
      else if(data.original_image_url)
        $t.find(".post-image").attr("src", data.original_image_url);
      if(data.original_content)
        $t.find(".post-content.post-original").html(data.original_content);
      $t.find(".post-link").attr("href", "/posts/"+data.id);
      if(typeof data.original_content === "undefined") {
        $t.find(".recommendation").remove();
      }
      $t.find("form").attr("action", "/posts/"+data.id+"/comments");

      $t.find("[detail_type=Post].tipoff").attr("detail_id", data.id);
      $t.find("[detail_type=Account].tipoff").attr("detail_id", data.creator_id);
      return $t;
    },
    recommend: function(data) {
      var $t = $($(".templates .recommend-template").html());
      $t.find("form").attr("action", "/posts/"+data.id+"/recommend");
      $t.find(".creator-name").attr("href", "/users/"+data.creator_id).html(data.creator_nick_name+":");
      $t.find(".post-content").html($.trim(data.content).substring(0, 50)+"...");
      return $t;
    },
    comment: function(data) {
      var $t = $($(".templates .comment-template").html());
      $t.attr("comment_id", data.id).attr("nick_name", data.creator_nick_name);
      $t.find(".creator-avatar").attr("src", data.creator_avatar);
      $t.find(".creator-name").html(data.creator_nick_name);
      $t.find(".creator-link").attr("href", "/users/"+data.creator_id);
      $t.find(".comment-content").html(data.comment);
      $t.find(".comment-time").html(data.created_at);
      if(data.original_author_id) {
        $t.find(".target-link").attr("href", "/users/"+data.original_author_id).html(data.original_author_nick_name);
      }
      else
        $t.find(".replay-tag").remove();

      return $t;
    }
  };
}
