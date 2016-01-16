json.extract! @recipe, :id, :name, :description, :created_at, :updated_at,
  :style_name, :abv, :ibu, :og, :fg, :color, :batch_size, :style_guide
json.url recipe_url(@recipe)
json.beerxml_url recipe_url(@recipe, format: :xml)
json.brewer do
  json.name @recipe.brewer_name
  json.url user_url(@recipe.user)
  json.brewery @recipe.user.brewery
  json.avatar @recipe.user.avatar_image
end
json.comments @recipe.thread.comments do |comment|
  json.body comment.body
  json.created_at comment.created_at
  json.creator do
    json.name comment.creator.name
    json.avatar comment.creator.avatar_image
  end
end
