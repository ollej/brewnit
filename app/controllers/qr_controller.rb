class QrController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  layout 'print'

  def show
    @recipe = Recipe.find(params[:id])
    @qrcode = RQRCode::QRCode.new(recipe_url(@recipe)).as_svg
  end
end
