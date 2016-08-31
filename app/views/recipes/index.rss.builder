xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0',
  'xmlns:media' => 'http://search.yahoo.com/mrss/',
  'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title 'Brygglogg.se'
    xml.description 'En svensk brygglogg för hembryggningsrecept.'
    xml.link recipes_url
    xml.generator 'Brygglogg.se'
    xml.category 'Homebrew'
    xml.image asset_url('brygglogg-logo.png')
    xml.language 'sv-SE'

    for recipe in @recipes
      xml.item do
        xml.title recipe.name
        xml.category recipe.style_name
        xml.description recipe.display_desc
        xml.author recipe.brewer_name
        xml.pubDate recipe.created_at.to_s(:rfc822)
        xml.link recipe_url(recipe)
        xml.guid recipe_url(recipe)
        xml.media(:content, url: full_url_for(recipe.main_image(:large)))
        xml.media(:thumbnail, url: full_url_for(recipe.main_image(:large_thumbnail)))
        xml.source recipes_url(format: :rss)
      end
    end
  end
end
