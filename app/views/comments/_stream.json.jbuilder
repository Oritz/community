json.id comment.id
json.comment comment.comment
json.creator_id comment.author_id
json.creator_avatar comment.creator_avatar
json.creator_nick_name comment.creator_nick_name
json.created_at comment.created_at
if comment.original_author
  json.original_author_id comment.original_author_id
  json.original_author_nick_name comment.original_author_nick_name
  json.original_author_avatar comment.original_author_avatar
end