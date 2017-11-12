class RecipePlacementsController < ApplicationController
  before_action :deny_spammers!

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @placement = @recipe.placements.find(params[:id])
    @event = @placement.event
    raise AuthorizationException unless @event.official? && current_user.can_modify?(@event)

    @success = true
    begin
      @placement.destroy!
    rescue StandardError => e
      Rails.logger.debug { "Exception: #{e.inspect}" }
      @success = false
    end

    respond_to do |format|
      if @success
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), notice: I18n.t(:'recipe_placements.delete.successful') }
        format.json { head :no_content }
      else
        @error_message = I18n.t(:'recipe_placements.destroy.failed')
        format.js
        format.html { redirect_to edit_recipe_path(@recipe), flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end
end
