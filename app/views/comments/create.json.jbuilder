json.status "success"
json.data do
  json.partial! 'stream', comment: @comment
end