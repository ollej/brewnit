class LabelController < ApplicationController
  def new
    @recipe = Recipe.find(params[:id])
    @logo_url = full_url_for(logo_url)
    @qrcode = ImageData.new(qrcode).data
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
    template = IO.read Rails.root.join('app', 'assets', 'labeltemplates', 'back-label.svg')
    LabelTemplate.new(template, data).generate
  end

  def data
    label_params.merge(
      qrcode: qrcode,
      logo: logo
    )
  end

  def logo
    path = logo_path
    File.open(path, 'rb') { |f| f.read } if path.present?
  end

  def logo_url
    if @recipe.user.present? && @recipe.user.media_brewery.present?
      @recipe.user.media_brewery.file.url(:label)
    end
  end

  def logo_path
    if @recipe.user.present? && @recipe.user.media_brewery.present?
      @recipe.user.media_brewery.file.path(:label)
    end
  end

  def qrcode
    RQRCode::QRCode.new(recipe_url(@recipe)).as_png(
      size: 236,
      border_modules: 1
    ).to_s
  end

  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4, :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo)
  end
end
