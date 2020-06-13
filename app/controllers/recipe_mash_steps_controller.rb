class RecipeMashStepsController < ApplicationController
  before_action :deny_spammers!
  before_action -> { load_and_authorize_recipe!(:mash_steps) }

  def index
    @mash_steps = @details.mash_steps

    respond_to do |format|
      format.json { render json: @mash_steps, status: :ok }
    end
  end

  def create
    @mash_step = MashStep.new(mash_step_params)

    respond_to do |format|
      if @mash_step.save
        @details.mash_steps << @mash_step
        format.html { redirect_to recipe_details_path }
        format.json { render json: @mash_step, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @mash_step.errors.full_messages.to_sentence
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
    @mash_step = @details.mash_steps.find(params[:id])

    respond_to do |format|
      if @mash_step.destroy
        format.html { redirect_to recipe_details_path }
        format.json { render layout: false, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @mash_step.errors.full_messages.to_sentence
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

  def mash_step_params
    params.require(:mash_step).permit(
      :name, :step_temperature, :step_time, :water_grain_ratio, :infuse_amount,
      :infuse_temperature, :ramp_time, :end_temperature, :mash_type
    )
  end
end
