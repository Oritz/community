json.status "success"
json.data do
  json.partial! 'posts/stream', post: @talk
end