class RecipeEventsController < ApplicationController
  before_action :deny_spammers!

  def create
    @recipe = Recipe.find(event_params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @success = true
    @event = begin
      @recipe.add_event(
        event_id: event_params[:event_id],
        user: current_user,
        recipe: @recipe,
        placement: placement_params
      )
    rescue StandardError => e
      Rails.logger.debug { "Exception: #{e.inspect}" }
      @success = false
    end

    respond_to do |format|
      if @success
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), notice: I18n.t(:'recipe_events.create.successful') }
        format.json { head :created, location: @recipe }
      else
        @error_message = I18n.t(:'recipe_events.create.failed')
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(event_params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @success = true
    begin
      @event = @recipe.events.find(params[:id])
      @recipe.remove_event(@event)
    rescue StandardError => e
      Rails.logger.debug { "Exception: #{e.inspect}" }
      @success = false
    end

    respond_to do |format|
      if @success
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), notice: I18n.t(:'recipe_events.delete.successful') }
        format.json { head :no_content }
      else
        @error_message = I18n.t(:'recipe_events.destroy.failed')
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end

  private
    def event_params
      params.permit(:recipe_id, :event_id)
    end

    def placement_params
      params.permit(:medal, :category)
    end
end
