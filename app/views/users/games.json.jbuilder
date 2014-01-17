json.status "success"
json.data do
  json.array! @games, :id, :image, :name
end