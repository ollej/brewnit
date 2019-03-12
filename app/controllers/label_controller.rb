require 'py3o_fusion'

class LabelController < ApplicationController
  def new
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = Recipe.find(params[:id])
    pdf = Tempfile.new "etiketter.pdf", Rails.root.join("pdf")
    Rails.logger.debug { "path to generated label file: #{pdf.path}" }
    generate pdf, data
    send_file pdf.path, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment
    #pdf.unlink # FIXME: Needs cleanup, as we need to keep this until nginx has delivered the file
  end

  private
  def generate(file, data)
    Rails.logger.debug { "Endpoint: #{ENV.fetch('PY3OFUSION_ENDPOINT')}" }
    Rails.logger.debug { "path to generated label template: #{Rails.root.join('files', 'label_template.odt')}" }
    Rails.logger.debug { "data: #{data}" }
    # TODO: Fix py3o.fusion so it only needs each image once
    # TODO: Create background job to create pdf
    # TODO: Setup X-Accel-Redirect and X-Accel-Mapping in dokku nginx
    # TODO: Setup X-Accel-Redirect and X-Accel-Mapping in vagrant nginx
    #if @recipe.user.media_brewery.present?
    if true
      (1..9).each do |i|
        # TODO: Seems to require all images
        #py3o_fusion.static_image("logo#{i}", @recipe.user.media_brewery.file)
        py3o_fusion.static_image("logo#{i}", @recipe.user.media_avatar.file.path)
      end
    end
    (1..9).each do |i|
      py3o_fusion.static_image("qrcode#{i}", qrcode.path)
    end
    Rails.logger.debug { py3o_fusion.send(:payload) }
    py3o_fusion.generate_pdf(file.path)
    file.rewind
    qrcode.unlink
  end

  def py3o_fusion
    @py3o ||= Py3oFusion.new(
      ENV.fetch('PY3OFUSION_ENDPOINT'),
      logger: Rails.logger,
      timeout: 240)
      .template(Rails.root.join('files', 'label_template.odt'))
      .data(data)
  end

  def qrcode
    return @qrcode if @qrcode.present?
    @qrcode = Tempfile.new('qrcode.png')
    RQRCode::QRCode.new(recipe_url(@recipe)).as_png(file: @qrcode.path)
    @qrcode.close
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
