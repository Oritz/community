json.status "success"
json.data do
  json.array! @comments, partial: 'stream', as: :comment
end