json.id post.id
json.detail_type post.detail_type
json.comment_count post.comment_count
json.recommend_count post.recommend_count
json.like_count post.like_count
json.created_at post.created_at
json.creator_id post.account_id
json.creator_nick_name post.creator_nick_name
json.creator_avatar post.creator_avatar
json.creator_level post.creator_level
json.image_url post.image_url if post.image
if post.detail_type == "Talk"
  json.content post.content
elsif post.detail_type == "Subject"
  json.content post.content
  json.title post.title
else
  json.original_content post.original_content
  json.original_title post.original_title if post.original.detail_type == "Subject"
  json.recommendation post.recommendation
end
