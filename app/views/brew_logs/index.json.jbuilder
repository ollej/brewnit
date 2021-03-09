json.array!(@brew_logs) do |brew_log|
  json.extract! brew_log, :id, :description, :brewers, :equipment, :brewed_at, :bottled_at,
    :og, :fg, :preboil_og, :mash_ph, :batch_volume, :boil_volume, :fermenter_volume,
    :bottled_volume
  json.recipe_url recipe_url(brew_log.recipe)
  json.recipe_json_url recipe_url(brew_log.recipe, format: :json)
  json.beerxml_url recipe_url(brew_log.recipe, format: :xml)
  json.image full_url_for(brew_log.recipe.main_image(:large))
  json.brewer do
    json.name brew_log.user.name
    json.url user_url(brew_log.user)
    json.brewery brew_log.user.brewery
    json.avatar full_url_for(brew_log.user.avatar_image)
  end
end
