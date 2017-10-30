class EventRecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  # GET /event/:event_id/recipes.json
  # GET /event/:event_id/recipes.csv
  # GET /event/:event_id/recipes.rss
  def index
    @recipes = Event.find(params[:event_id]).recipes.order(name: :asc)
    @filename = "recipes-event-#{params[:event_id]}-#{Date.today}.csv"

    respond_to do |format|
      format.rss { render layout: false, template: 'recipes/index' }
      format.json { render layout: false, template: 'recipes/index' }
      format.csv
    end
  end


end
