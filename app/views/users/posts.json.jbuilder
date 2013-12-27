json.status "success"
json.data do
  json.array! @stream_posts, partial: 'posts/stream', as: :post
end
