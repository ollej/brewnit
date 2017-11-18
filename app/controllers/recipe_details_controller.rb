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
    if @details.update(details_params)
      redirect_to edit_recipe_details_path
    else
      flash[:error] = @details.errors.full_messages.to_sentence
      redirect_to edit_recipe_details_path
    end
  end

  private

  def load_and_authorize_recipe
    @recipe = Recipe.includes(detail: [:fermentables, :hops, :miscs, :yeasts]).find(params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end
end
