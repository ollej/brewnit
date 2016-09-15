xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0',
  'xmlns:media' => 'http://search.yahoo.com/mrss/',
  'xmlns:atom' => 'http://www.w3.org/2005/Atom',
  'xmlns:webfeeds' => 'http://webfeeds.org/rss/1.0' do
  xml.channel do
    xml.title 'Brygglogg.se'
    xml.description 'En svensk brygglogg för hembryggningsrecept.'
    xml.link recipes_url
    xml.generator 'Brygglogg.se'
    xml.category 'Homebrew'
    xml.image asset_url('brygglogg-logo.png')
    xml.tag!('webfeeds:cover', image: asset_url('brygglogg-logo.png'))
    xml.tag!('webfeeds:icon', asset_url('favicon/favicon.ico'))
    xml.tag!('webfeeds:accentColor', 'FFCD40')
    xml.tag!('webfeeds:related', layout: 'card', target: 'browser')
    xml.language 'sv-SE'

    for recipe in @recipes
      xml.item do
        image = full_url_for(recipe.main_image(:large))
        desc = render partial: 'recipe_description', formats: :html, locals: { recipe: recipe }
        xml.title recipe.name
        xml.category recipe.style_name
        xml.description { xml.cdata! desc }
        xml.author recipe.brewer_name
        xml.pubDate recipe.created_at.to_s(:rfc822)
        xml.link recipe_url(recipe)
        xml.guid recipe_url(recipe)
        xml.media(:content, url: image)
        xml.media(:thumbnail, url: full_url_for(recipe.main_image(:large_thumbnail)))
        xml.tag!('webfeeds:featuredImage', url: image)
        xml.source recipes_url(format: :rss)
      end
    end
  end
end
