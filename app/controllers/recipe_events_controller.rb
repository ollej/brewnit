class RecipeEventsController < ApplicationController
  before_action :deny_spammers!

  def destroy
    @recipe = Recipe.find(event_params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
    @event = @recipe.events.find(event_params[:id])

    respond_to do |format|
      if @recipe.events.delete(@event)
        format.html { redirect_to recipe_path(@recipe), notice: I18n.t(:'recipe_events.delete.successful') }
        format.json { head :no_content }
      else
        format.html { redirect_to recipe_path(@recipe), flash: { error: I18n.t(:'recipe_events.delete.failed') } }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def event_params
      params.permit(:recipe_id, :id)
    end
end
