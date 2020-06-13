class RecipeShoppingListController < ApplicationController
  before_action :load_and_authorize_show_recipe!
  layout 'print'

  def show
    @presenter = RecipePresenter.new(@recipe)
    @shopping = IngredientList.new(@recipe).build
  end
end
