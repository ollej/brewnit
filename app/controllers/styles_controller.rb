class StylesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @style, status: :ok }
    end
  end
end
