xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0',
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

    for event in @events
      xml.item do
        xml.title event.name
        xml.category event.event_type
        xml.description { xml.cdata! event.description }
        xml.author event.user.display_name
        xml.pubDate event.created_at.to_s(:rfc822)
        xml.link event_url(event)
        xml.guid event_url(event)
        xml.source events_url(format: :rss)
      end
    end
  end
end
