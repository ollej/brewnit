class RecipeMiscsController < ApplicationController
  before_action :deny_spammers!
  before_action :load_and_authorize_recipe

  def index
    @miscs = @recipe_detail.miscs

    respond_to do |format|
      format.json { render json: @miscs, status: :ok }
    end
  end

  def create
    @misc = Misc.new(misc_params)
    respond_to do |format|
      if @misc.save
        @recipe_detail.miscs << @misc
        format.html { redirect_to recipe_details_path }
        format.json { render json: @misc, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @misc.errors.full_messages.to_sentence
        format.html {
          flash[:error] = @error
          redirect_to recipe_details_path
        }
        format.json { render json: { error: @error }, status: :unprocessable_entity, location: recipe_details_path }
        format.js { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
      end
    end
  end

  def destroy
    @misc = @recipe_detail.miscs.find(params[:id])
    respond_to do |format|
      if @misc.destroy
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @misc.errors.full_messages.to_sentence
        format.html {
          flash[:error] = @error
          redirect_to recipe_details_path
        }
        format.json { render json: { error: @error }, status: :unprocessable_entity, location: recipe_details_path }
        format.js { render layout: false, status: :unprocessable_entity, location: recipe_details_path }
      end
    end
  end

  private

  def misc_params
    params.require(:misc).permit(:name, :amount, :weight, :use, :use_time, :misc_type)
  end

  def load_and_authorize_recipe
    @recipe = Recipe.includes(:detail).find(params[:recipe_id])
    @recipe_detail = @recipe.detail
    raise AuthorizationException unless current_user.can_modify?(@recipe)
  end
end