class RecipeCompleteController < ApplicationController
  before_action :load_and_authorize_recipe
  before_action :deny_spammers!, only: [:update]
  invisible_captcha only: [:update], on_spam: :redirect_spammers!

  def update
    @details = @recipe.detail
    @hops = @details.hops
    @fermentables = @details.fermentables
    @miscs = @details.miscs
    @yeasts = @details.yeasts
    @mash_steps = @details.mash_steps
    @style = @details.style
    @recipe.beerxml = render_to_string(template: 'recipe_details/show.xml.builder')
    BeerxmlImport.new(@recipe, @recipe.beerxml).extract_recipe
    @recipe.save!

    respond_to do |format|
      format.html { redirect_to recipe_details_path }
      format.json { render json: @details, status: :ok, location: recipe_details_path }
    end
  end

  private

  def load_and_authorize_recipe
    @recipe = Recipe.includes(detail: [:fermentables, :hops, :miscs, :yeasts, :style]).find(params[:recipe_id])
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end
end