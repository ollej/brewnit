class RecipePosterController < ApplicationController
  before_action :load_and_authorize_show_recipe!
  layout 'print'

  def show
    @beerxml = BeerxmlParser.new(@recipe.beerxml).recipe
    @presenter = RecipePresenter.new(@recipe, @beerxml)
  end
end
