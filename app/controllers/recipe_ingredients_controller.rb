class RecipeIngredientsController < ApplicationController
  before_action :deny_spammers!
  before_action :load_and_authorize_recipe

  def index
  end

  def create
    @recipe_detail.add_ingredient(params[:type], ingredient_params)
    head :created
  end

  def destroy
    @ingredient = @recipe_detail.find_ingredient(params[:type], params[:id])
    @ingredient.destroy!
    head :ok
  end

  def update
    @ingredient = @recipe_detail.find_ingredient(params[:type], params[:id])
    @ingredient.update!(ingredient_params)
    head :ok
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(*type_attributes(params[:type]))
  end

  def type_attributes(type)
    case type
    when 'fermentables'
      %i(name amount yield potential ebc after_boil fermentable)
    when 'hops'
     %i(name amount alpha_acid form use use_time)
    when 'miscs'
     %i(name amount weight use use_time)
    when 'yeasts'
     %i(name amount weight form)
    else
      raise IngredientTypeUnknown
    end
  end

  def load_and_authorize_recipe
    @recipe = Recipe.includes(recipe_details: [:fermentables, :hops, :miscs, :yeasts]).find(params[:recipe_id])
    @recipe_detail = @recipe.detail
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end

end
