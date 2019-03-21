class RecipeHopsController < ApplicationController
  before_action :deny_spammers!
  before_action -> { load_and_authorize_recipe!(:hops) }

  def index
    @hops = @details.hops

    respond_to do |format|
      format.json { render json: @hops, status: :ok }
    end
  end

  def create
    @hop = Hop.new(hop_params)
    respond_to do |format|
      if @hop.save
        @details.hops << @hop
        format.html { redirect_to recipe_details_path }
        format.json { render json: @hop, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @hop.errors.full_messages.to_sentence
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
    @hop = @details.hops.find(params[:id])
    respond_to do |format|
      if @hop.destroy
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @hop.errors.full_messages.to_sentence
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

  def hop_params
    params.require(:hop).permit(:name, :amount, :alpha_acid, :form, :use, :use_time)
  end
end
