class QrController < ApplicationController
  before_action :load_and_authorize_show_recipe!
  layout 'print'

  def show
    @qrcode = RQRCode::QRCode.new(recipe_url(@recipe)).as_svg
  end
end
