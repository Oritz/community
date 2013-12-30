json.status "success"
json.data do
  json.partial! 'stream', post: @recommend
end
