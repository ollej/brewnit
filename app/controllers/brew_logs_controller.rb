class BrewLogsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :deny_spammers!, only: [:create, :destroy]
  invisible_captcha only: [:create], on_spam: :redirect_spammers!

  def index
    @recipe = Recipe.find(params[:recipe_id])
    @brew_logs = @recipe.brew_logs.persisted

    respond_to do |format|
      format.html { render :index }
      format.json { render :index }
    end
  end

  def show
    @brewlog = BrewLog.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @brew_log }
    end
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @brewlog = @recipe.brew_logs.build(brew_log_params)
    @brewlog.user = current_user

    respond_to do |format|
      if @brewlog.save
        format.js
        format.html { redirect_to @recipe, notice: I18n.t(:'brewlogs.create.successful') }
        format.json { head :created, location: @recipe }
      else
        @error_message = I18n.t(:'brewlogs.create.failed', error: @brewlog.errors.full_messages)
        format.js
        format.html { redirect_to @recipe, flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @brewlog = BrewLog.find(params[:id])
    authorize_modify!(@brewlog)

    respond_to do |format|
      if @brewlog.destroy
        format.js
        format.html { redirect_to @recipe, notice: I18n.t(:'brewlogs.destroy.successful') }
        format.json { head :no_content }
      else
        @error_message = I18n.t(:'brewlogs.destroy.failed', error: @brewlog.errors.full_messages)
        format.js
        format.html { redirect_to @recipe, flash: { error: @error_message } }
        format.json { render json: { error: @error_message }, status: :unprocessable_entity }
      end
    end
  end

  private
    def brew_log_params
      params.require(:brew_log).permit(
        :recipe_id, :description, :brewers, :equipment, :brewed_at, :bottled_at,
        :og, :fg, :preboil_og, :mash_ph, :batch_volume, :boil_volume, :fermenter_volume,
        :bottled_volume)
    end
end
