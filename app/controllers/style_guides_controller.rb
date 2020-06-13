class StyleGuidesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @style_guides = Style.style_guides

    respond_to do |format|
      format.html
      format.json { render json: @style_guides, status: :ok }
    end
  end

  def show
    @styles = Style.for_guide(params[:guide])
    @style_guide = params[:guide]

    respond_to do |format|
      format.html
      format.js { render layout: false, status: :ok }
      format.json { render json: @styles, status: :ok }
    end
  end
end
