class RecipeYeastsController < ApplicationController
  before_action :deny_spammers!
  before_action -> { load_and_authorize_recipe!(:yeasts) }

  def index
    @yeasts = @details.yeasts

    respond_to do |format|
      format.json { render json: @yeasts, status: :ok }
    end
  end

  def create
    @yeast = Yeast.new(yeast_params)
    respond_to do |format|
      if @yeast.save
        @details.yeasts << @yeast
        format.html { redirect_to recipe_details_path }
        format.json { render json: @yeast, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @yeast.errors.full_messages.to_sentence
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
    @yeast = @details.yeasts.find(params[:id])
    respond_to do |format|
      if @yeast.destroy
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @yeast.errors.full_messages.to_sentence
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

  def yeast_params
    params.require(:yeast).permit(:name, :amount, :weight, :yeast_type, :form)
  end
end
