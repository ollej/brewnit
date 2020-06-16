class CloneRecipeController < ApplicationController
  before_action :deny_spammers!, only: [:create]
  invisible_captcha only: [:create], on_spam: :redirect_spammers!

  def new
    @recipe = Recipe.find(params[:id])
    @clone_recipe_id = @recipe.id
    @clone_recipe_name = clone_name(@recipe)
  end

  def create
    @recipe = Recipe.find(params[:id])
    @clone = RecipeCloner.new(@recipe, current_user, clone_params).clone

    if @clone.save!
      RecipeMailer.with(user: @recipe.user, recipe: @recipe, clone: @clone).recipe_cloned.deliver_later
      redirect_to @clone, notice: I18n.t(:'clone_recipe.create.successful')
    else
      flash[:error] = I18n.t(:'clone_recipe.create.failed')
      redirect_to @recipe
    end
  end

  private

  def clone_name(recipe)
    "#{recipe.name} #{I18n.t(:'clone_recipe.clone_name_suffix')}"
  end

  def clone_params
    params.permit(:name)
  end
end
