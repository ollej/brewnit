class LabelController < ApplicationController
  before_action :load_and_authorize_recipe_by_id!

  def new
    @preview_svg = label_templates.template(recipe_data)
    @logo_url = full_url_for(logo.url(:label)) if logo.present?
    if mainimage.present?
      @mainimage_url = full_url_for(mainimage.url(:label_main))
      @mainimage_wide_url = full_url_for(mainimage.url(:label_main_wide))
      @mainimage_full_url = full_url_for(mainimage.url(:label_main_full))
    end
    @qrcode = ImageData.new(qrcode).data
    @recipe_data = recipe_data
    @templates = label_templates.list
  end

  def create
    send_data render_pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment
  end

  private
  def label_templates
    @label_templates ||= LabelTemplates.new(template: label_params[:template] || LabelTemplates::DEFAULT)
  end

  def render_pdf
    LabelMaker.new(label_templates.template(params_data)).generate
  end

  def params_data
    label_params.merge(images)
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
    }.merge(beer_description_lines).merge(images)
  end

  def images
    {
      logo: readfile(logo),
      qrcode: qrcode,
      mainimage: readfile(mainimage, :label_main),
      mainimage_wide: readfile(mainimage, :label_main_wide),
      mainimage_full: readfile(mainimage, :label_main_full)
    }
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

  def readfile(file, size = :label)
    File.open(file.path(size), 'rb') { |f| f.read } if file.present?
  end

  def logo
    if @recipe.user.present? && @recipe.user.media_brewery.present?
      @recipe.user.media_brewery.file
    end
  end

  def mainimage
    if @recipe.media_main.present?
      @recipe.media_main.file
    end
  end

  def qrcode
    RQRCode::QRCode.new(recipe_url(@recipe)).as_png(
      size: 236,
      border_modules: 1
    ).to_s
  end

  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4,
                  :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo,
                  :template)
  end
end
