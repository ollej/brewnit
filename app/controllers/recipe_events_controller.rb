class RecipeEventsController < ApplicationController
  before_action :deny_spammers!

  def create
    @recipe = Recipe.find(event_params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @event = Event.find(event_params[:event_id])
    @success = true
    begin
      @recipe.events << @event
    rescue ActiveRecord::RecordNotUnique
      @success = false
    end

    respond_to do |format|
      if @success
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), notice: I18n.t(:'recipe_events.create.successful') }
        format.json { head :created, location: @recipe }
      else
        error_message = I18n.t(:'recipe_events.create.failed')
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), flash: { error: error_message } }
        format.json { render json: { error: error_message }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(event_params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @event = @recipe.events.find(params[:id])

    respond_to do |format|
      if @recipe.events.delete(@event)
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), notice: I18n.t(:'recipe_events.delete.successful') }
        format.json { head :no_content }
      else
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), flash: { error: I18n.t(:'recipe_events.delete.failed') } }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def event_params
      params.permit(:recipe_id, :event_id)
    end
end
