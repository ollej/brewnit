class RecipePrintController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :load_and_authorize_show_recipe!
  layout 'print'

  def show
    @beerxml = BeerxmlParser.new(@recipe.beerxml).recipe
    @presenter = RecipePresenter.new(@recipe, @beerxml)
    @qrcode = RQRCode::QRCode.new(recipe_url(@recipe)).as_svg(viewbox: true)
  end
end
