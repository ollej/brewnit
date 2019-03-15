class LabelController < ApplicationController
  def new
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.find(params[:id])
    send_data render_pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment
  end

  private
  def render_pdf
    LabelMaker.new(template).generate
  end

  def template
    IO.read Rails.root.join('app', 'assets', 'labeltemplates', 'back-label.svg')
  end

  def data
    label_params.merge(
      qrcode: qrcode,
      logo: @recipe.user.media_avatar.file
    )
  end

  def qrcode
    RQRCode::QRCode.new(recipe_url(@recipe)).as_svg
  end

  def label_params
    params.permit(:name, :description, :abv, :ibu, :ebc, :bottledate, :bottlesize)
  end
end
