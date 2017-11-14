class EventRecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :deny_spammers!

  # GET /event/:event_id/recipes.json
  # GET /event/:event_id/recipes.rss
  # GET /event/:event_id/recipes.csv
  # GET /event/:event_id/recipes.xlsx
  def index
    @event = Event.find(params[:event_id])
    @recipes = @event.recipes.order(name: :asc)
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

  def create
    @event = Event.find(placement_params[:id])
    raise AuthorizationException unless @event.official? && current_user.can_modify?(@event)
    @recipe = Recipe.find(placement_params[:recipe_id])

    @success = true
    begin
      @recipe.add_event(
        event: @event,
        user: current_user,
        placement: placement_params
      )
    rescue StandardError => e
      Rails.logger.debug { "Exception: #{e.inspect}" }
      @success = false
    end

    respond_to do |format|
      if @success
        format.js
        format.html { redirect_to event_path(@event), notice: I18n.t(:'event_recipes.create.successful') }
        format.json { head :created }
      else
        @error_message = I18n.t(:'event_recipes.create.failed')
        format.js
        format.html { redirect_to event_path(@event), flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end

  private
    def placement_params
      params.require(:event).permit(:recipe_id, :id, :medal, :category)
    end
end
