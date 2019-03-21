class QrController < ApplicationController
  before_action :load_and_authorize_recipe_by_id!
  layout 'print'

  def show
    @qrcode = RQRCode::QRCode.new(recipe_url(@recipe)).as_svg
  end
end
