class RecipePosterController < ApplicationController
  layout 'print'
  before_action :load_and_authorize_recipe_by_id

  def show
    @recipe = Recipe.find(params[:id])
    raise AuthorizationException unless can_show?(@recipe)
    @beerxml = BeerxmlParser.new(@recipe.beerxml).recipe
    @presenter = RecipePresenter.new(@recipe, @beerxml)
  end
end
