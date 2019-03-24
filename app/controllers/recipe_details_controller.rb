class RecipeDetailsController < ApplicationController
  before_action :deny_spammers!, only: [:update]
  before_action :load_and_authorize_recipe!
  invisible_captcha only: [:create, :update], on_spam: :redirect_spammers!

  def show
    # Never cache this page to ensure browser reloads
    expires_now

    @details ||= RecipeDetail.create!(recipe_id: @recipe.id)
    @hops = @details.hops
    @fermentables = @details.fermentables
    @miscs = @details.miscs
    @yeasts = @details.yeasts
    @mash_steps = @details.mash_steps
    @style = @details.style
    @styles = Style.style_options(@style&.style_guide || 'SHBF 2018')

    respond_to do |format|
      format.html
      format.xml {
        send_data render_to_string(:show),
            filename: 'recipe.xml',
            type: 'application/xml',
            disposition: 'attachment'
      }
    end
  end

  def update
    respond_to do |format|
      if @details.update(details_params)
        format.html { redirect_to recipe_details_path }
        format.json { render json: @details, status: :ok, location: recipe_details_path }
        format.js { render layout: false, status: :ok, location: recipe_details_path }
      else
        @error = @details.errors.full_messages.to_sentence
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

  def details_params
    details = params.require(:recipe_detail).permit(
      :batch_size, :boil_size, :boil_time, :grain_temp, :sparge_temp, :efficiency,
      :og, :fg, :brewed_at, :carbonation, :style
    )
    details[:style] = Style.find(details[:style]) if details[:style].present?
    details
  end
end
