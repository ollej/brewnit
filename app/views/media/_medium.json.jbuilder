json.id medium.id
json.url medium.file.url
json.thumbnail do
  json.small medium.file.url(:small_thumbnail)
  json.medium medium.file.url(:medium_thumbnail)
  json.large medium.file.url(:large_thumbnail)
end
json.scaled do
  json.small medium.file.url(:small)
  json.medium medium.file.url(:medium)
  json.large medium.file.url(:large)
end
