class RecipePosterController < ApplicationController
  before_action :load_and_authorize_recipe_by_id!
  layout 'print'

  def show
    @beerxml = BeerxmlParser.new(@recipe.beerxml).recipe
    @presenter = RecipePresenter.new(@recipe, @beerxml)
  end
end
