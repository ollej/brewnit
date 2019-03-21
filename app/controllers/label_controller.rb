class LabelController < ApplicationController
  before_action :load_and_authorize_recipe_by_id!

  def new
    @preview_svg = label_template(recipe_data)
    @logo_url = full_url_for(logo_url) if logo_url
    @qrcode = ImageData.new(qrcode).data
    @recipe_data = recipe_data
  end

  def create
    send_data render_pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment
  end

  private
  def render_pdf
    LabelMaker.new(label_template(params_data)).generate
  end

  def label_template(data)
    LabelTemplate.new(template_file, data).generate
  end

  def template_file
    IO.read Rails.root.join('app', 'assets', 'labeltemplates', 'back-label.svg')
  end

  def params_data
    label_params.merge(
      qrcode: qrcode,
      logo: logo
    )
  end

  def recipe_data
    {
      name: @recipe.name,
      abv: view_context.number_with_precision(@recipe.abv, precision: 0),
      ibu: view_context.number_with_precision(@recipe.ibu, precision: 0),
      ebc: view_context.number_with_precision(@recipe.color, precision: 0),
      og: view_context.format_sg(@recipe.og),
      fg: view_context.format_sg(@recipe.fg),
      brewdate: I18n.l(@recipe.created_at.to_date),
      bottlesize: '50 cl',
      logo: logo,
      qrcode: qrcode
    }.merge(beer_description_lines)
  end

  def beer_description_lines
    description = Sanitizer.new(html_entity_decode: true)
      .sanitize(@recipe.description)
    lines = WordWrap.ww(description, 28).split("\n")
    {
      description1: lines[0],
      description2: lines[1],
      description3: lines[2],
      description4: lines[3]
    }
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
