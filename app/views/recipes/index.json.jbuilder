json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :name, :description, :beerxml, :public
  json.url recipe_url(recipe, format: :json)
end
