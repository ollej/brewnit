class RecipeDetailsController < ApplicationController
  before_action :load_and_authorize_recipe
  before_action :deny_spammers!, only: [:update]
  invisible_captcha only: [:create, :update], on_spam: :redirect_spammers!

  def edit
    @details = RecipeDetail.find_or_create_by!(recipe_id: @recipe.id)
    @hops = @details.hops
    @fermentables = @details.fermentables
    @miscs = @details.miscs
    @yeasts = @details.yeasts
  end

  def update
    @details = @recipe.detail

    respond_to do |format|
      if @details.update(details_params)
        format.html { redirect_to recipe_details_path }
        format.json { render json: @details, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @details.errors.full_messages.to_sentence
        format.html {
          flash[:error] = @error
          redirect_to recipe_details_path
        }
        format.json { render json: { error: @error }, status: :unprocessable_entity, location: recipe_details_path }
        format.js { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
      end
    end
  end

  private

  def details_params
    params.require(:recipe_detail).permit(:batch_size, :boil_size, :boil_time, :grain_temp, :sparge_temp, :efficiency)
  end

  def load_and_authorize_recipe
    @recipe = Recipe.includes(detail: [:fermentables, :hops, :miscs, :yeasts]).find(params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end
end
