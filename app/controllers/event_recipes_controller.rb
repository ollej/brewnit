class EventRecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  # GET /event/:event_id/recipes.json
  # GET /event/:event_id/recipes.rss
  # GET /event/:event_id/recipes.csv
  # GET /event/:event_id/recipes.xlsx
  def index
    @recipes = Event.find(params[:event_id]).recipes.order(name: :asc)
    basename = "recipes-event-#{params[:event_id]}-#{Date.today}"
    @filename = "#{basename}.csv"

    respond_to do |format|
      format.json { render layout: false, template: 'recipes/index' }
      format.rss { render layout: false, template: 'recipes/index' }
      format.csv
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename='#{basename}.xlsx'"
      }
    end
  end


end
