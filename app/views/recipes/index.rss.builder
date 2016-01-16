xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'Brygglogg.se'
    xml.description 'En svensk brygglogg för hembryggningsrecept.'
    xml.link recipes_url

    for recipe in @recipes
      xml.item do
        xml.title recipe.name
        xml.category recipe.style_name
        xml.description recipe.display_desc
        xml.author recipe.brewer_name
        xml.pubDate recipe.created_at.to_s(:rfc822)
        xml.link recipe_url(recipe)
        xml.guid recipe_url(recipe)
      end
    end
  end
end
