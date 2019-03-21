class RecipeFermentablesController < ApplicationController
  before_action :deny_spammers!
  before_action -> { load_and_authorize_recipe!(:fermentables) }

  def index
    @fermentables = @details.fermentables

    respond_to do |format|
      format.json { render json: @fermentables, status: :ok }
    end
  end

  def create
    @fermentable = Fermentable.new(fermentable_params)

    respond_to do |format|
      if @fermentable.save
        @details.fermentables << @fermentable
        format.html { redirect_to recipe_details_path }
        format.json { render json: @fermentable, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @fermentable.errors.full_messages.to_sentence
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
    @fermentable = @details.fermentables.find(params[:id])

    respond_to do |format|
      if @fermentable.destroy
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @fermentable.errors.full_messages.to_sentence
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

  def fermentable_params
    params.require(:fermentable).permit(:name, :amount, :yield, :potential, :ebc, :after_boil, :fermentable, :grain_type)
  end
end
