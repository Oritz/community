json.id post.id
json.content post.content
json.comment_count post.comment_count
json.recommend_count post.recommend_count
json.like_count post.like_count
json.created_at post.created_at
json.creator_id post.account_id
json.creator_nick_name post.creator_nick_name
json.creator_avatar post.creator_avatar
json.creator_level post.creator_level
if post.is_talk?
  json.image_url post.image_url if post.image
elsif post.is_subject?
  json.image_url post.image_url if post.image
else
  json.original_content post.original_content
  json.original_image_url post.original_image_url if post.original.image
end
