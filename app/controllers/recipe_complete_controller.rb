class RecipeCompleteController < ApplicationController
  before_action :deny_spammers!, only: [:update]
  before_action :load_and_authorize_recipe
  invisible_captcha only: [:update], on_spam: :redirect_spammers!

  def update
    @recipe.beerxml = BeerxmlExport.new(@recipe).render
    beer_recipe = BeerxmlParser.new(@recipe.beerxml).recipes.first
    BeerxmlImport.new(@recipe, beer_recipe).extract_recipe
    @recipe.save!

    respond_to do |format|
      format.html { redirect_to recipe_details_path }
      format.json { render json: @details, status: :ok, location: recipe_details_path }
    end
  end
end
