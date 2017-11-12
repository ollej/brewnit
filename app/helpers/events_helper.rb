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

end
