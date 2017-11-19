class RecipeYeastsController < ApplicationController
  before_action :deny_spammers!
  before_action :load_and_authorize_recipe

  def index
  end

  def create
    @yeast = Yeast.new(yeast_params)
    respond_to do |format|
      if @yeast.save
        @recipe_detail.yeasts << @yeast
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        flash[:error] = @yeast.errors.full_messages.to_sentence
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
        format.js { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
      end
    end
  end

  def destroy
    @yeast = @recipe_detail.yeast.find(params[:id])
    respond_to do |format|
      if @yeast.destroy
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        flash[:error] = @yeast.errors.full_messages.to_sentence
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
        format.js { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
      end
    end
  end

  def update
    @yeast = @recipe_detail.yeast.find(params[:id])
    respond_to do |format|
      if @yeast.update(yeast_params)
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        flash[:error] = @yeast.errors.full_messages.to_sentence
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
        format.js { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
      end
    end
  end

  private

  def yeast_params
    params.require(:yeast).permit(:name, :amount, :weight, :yeast_type, :form)
  end

  def load_and_authorize_recipe
    @recipe = Recipe.includes(:detail).find(params[:recipe_id])
    @recipe_detail = @recipe.detail
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end
end
