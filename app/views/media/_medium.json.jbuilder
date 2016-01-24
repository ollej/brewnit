json.id medium.id
json.url medium.file.url
json.destroy_url recipe_medium_path(medium.parent, medium)
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
json.template render partial: 'shared/image.html.erb', locals: { recipe: medium.parent, medium: medium }
