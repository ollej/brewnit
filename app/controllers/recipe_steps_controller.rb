class RecipeStepsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @recipe = find_recipe
    raise AuthorizationException unless can_show?(@recipe)
    @beerxml = @recipe.beerxml_details
  end

  private

  def find_recipe
    Recipe.unscoped.find(params[:id])
  end

end
