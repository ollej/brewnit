class RecipeStepsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @recipe = find_recipe
    raise AuthorizationException unless can_show?(@recipe)
    PushMessage.new(notification).notify
    @brew_steps = BrewStepsPresenter.new(@recipe)
  end

  private

  def find_recipe
    Recipe.unscoped.find(params[:id])
  end

  def notification
    {
      title: I18n.t('common.notification.brewtimer.opened.title'),
      message: I18n.t(
        'common.notification.brewtimer.opened.message', {
          user: current_user.display_name,
          recipe: @recipe.name
      }),
      sound: "gamelan",
      url: recipe_url(@recipe)
    }
  end
end
