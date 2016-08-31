json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :name, :description, :created_at, :updated_at,
  :style_name, :abv, :ibu, :og, :fg, :color, :batch_size, :style_guide
  json.url recipe_url(recipe)
  json.json_url recipe_url(recipe, format: :json)
  json.beerxml_url recipe_url(recipe, format: :xml)
  json.image full_url_for(recipe.main_image(:large))
  json.brewer do
    json.name recipe.brewer_name
    json.url user_url(recipe.user)
    json.brewery recipe.user.brewery
    json.avatar full_url_for(recipe.user.avatar_image)
  end
end
