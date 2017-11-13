module EventsHelper

  def official_badge(recipe)
    badge(
      I18n.t(:'events.official_badge_title'),
        type: 'official',
        icon: 'calendar-o',
        tooltip: I18n.t(:'events.official_badge_description')
    )
  end

  def recipes_badge(event)
    badge(
        I18n.t(:'events.recipe_count', count: event.recipes.size),
        type: 'event-recipes',
        icon: 'beer'
    )
  end

  def google_map(center)
    key = Rails.application.secrets.google_maps_api_key
    "https://maps.googleapis.com/maps/api/staticmap?center=#{center}&size=300x300&zoom=17&language=sv&key=#{key}"
  end

end
