class RegisterRecipeController < ApplicationController
  before_action :deny_spammers!, only: [:create]
  invisible_captcha only: [:create], on_spam: :redirect_spammers!

  def new
    @event = Event.official.find(params[:event_id]) if params[:event_id].present?
    recipes = Recipe.by_user(current_user).completed.order(name: :asc)
    @recipe_options = Recipe.recipe_options(recipes)
    @recipe = recipes.find(params[:recipe_id]) if params[:recipe_id].present?
  end

  def create
    @recipe = Recipe.by_user(current_user).completed.find(registration_params[:recipe])
    @event = Event.official.registration_open.find(registration_params[:event])
    raise AuthorizationException unless can_show?(@recipe)
    raise RecipeNotComplete unless @recipe.complete?
    @recipe.add_event(event: @event, user: current_user)
    @event.register_recipe(@recipe, current_user, registration_params)

    flash[:notice] = I18n.t(:'register_recipe.recipe_registered', event: @event.name, recipe: @recipe.name)

    redirect_to @event
  end

  private

  def registration_params
    params.require(:registration).permit(:message, :recipe, :event)
  end
end
