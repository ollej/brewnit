class RecipeEventsController < ApplicationController
  before_action :deny_spammers!

  def create
    @recipe = Recipe.find(event_params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @error = nil
    @event = begin
      @recipe.add_event(
        event: event_params[:id],
        user: current_user,
        placement: event_params
      )
    rescue StandardError => e
      Rails.logger.debug { "Exception: #{e.inspect}" }
      if e.respond_to? :record
        @error = e.record.errors
      else
        @error = e.name
      end
    end

    respond_to do |format|
      if @error.nil?
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), notice: I18n.t(:'recipe_events.create.successful') }
        format.json { head :created, location: @recipe }
      else
        @error_message = I18n.t(:'recipe_events.create.failed', error: @error)
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
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
      params.require(:event).permit(:recipe_id, :id, :medal, :category)
    end
end
