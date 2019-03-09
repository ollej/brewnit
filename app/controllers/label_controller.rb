require 'py3o_fusion'

class LabelController < ApplicationController
  def new
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.find(params[:id])
    pdf = Tempfile.new("etiketter.pdf")
    generate(pdf, data)
    respond_to do |format|
      format.pdf do
        send_data(pdf, filename: 'etiketter.pdf', type: 'application/pdf')
      end
    end
    pdf.unlink
  end

  private
  def generate(file, data)
    py3o = Py3oFusion.new(ENV.fetch('PY3OFUSION_ENDPOINT'))
      .template("files/label_template.odt")
      .data(data)
    if @recipe.user.media_brewery.present?
      (1..9).each do |i|
        py3o.static_image("logo#{i}", @recipe.user.media_brewery.file)
      end
    end
    (1..9).each do |i|
      py3o.static_image("qrcode{i}", qrcode)
    end
    py3o.generate_pdf(file)
    @qrcode.unlink
  end

  def qrcode
    return @qrcode if @qrcode.present?
    @qrcode = Tempfile.new('qrcode.svg')
    @qrcode.write(RQRCode::QRCode.new(recipe_url(@recipe)).as_svg)
    @qrcode
  end

  def data
    {
      'item': {
        'beername': label_params[:name],
        'description': label_params[:description],
        'abv': label_params[:abv],
        'ibu': label_params[:ibu],
        'ebc': label_params[:ebc],
        'bottledate': label_params[:bottledate],
        'bottlesize': label_params[:bottlesize]
      }
    }
  end

  def label_params
    params.permit(:name, :description, :abv, :ibu, :ebc, :bottledate, :bottlesize)
  end
end
