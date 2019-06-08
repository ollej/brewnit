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
    @templates = label_templates
  end

  def create
    push_message
    send_data render_pdf, filename: 'etiketter.pdf', type: :pdf, disposition: :attachment
  end

  private
  def push_message
    PushMessage.new(push_values).notify
  end

  def push_values
    {
      title: I18n.t(:'common.notification.label.created.title', recipe_data),
      message: I18n.t(:'common.notification.label.created.message', recipe_data),
      sound: :magic
    }
  end

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
      abv: "#{view_context.number_with_precision(@recipe.abv, precision: 1)}%",
      ibu: view_context.number_with_precision(@recipe.ibu, precision: 0),
      ebc: view_context.number_with_precision(@recipe.color, precision: 0),
      og: view_context.format_sg(@recipe.og),
      fg: view_context.format_sg(@recipe.fg),
      brewdate: I18n.l(@recipe.created_at.to_date),
      bottlesize: '50 cl',
      brewery: @recipe.brewer_name,
      beerstyle: @recipe.style_name,
      contactinfo: "",
      yeast: yeasts
    }.merge(beer_description_lines)
      .merge(malt_lines)
      .merge(hop_lines)
      .merge(images)
  end

  def ingredients
    @ingredients ||= IngredientList.new(@recipe).build
  end

  def fermentables
    ingredients.fermentables.map { |item| item.name }.join(", ")
  end

  def hops
    ingredients.hops.map { |item| item.name }.join(", ")
  end

  def yeasts
    ingredients.yeasts.map { |item| item.name }.join(", ")
  end

  def images
    {
      logo: readmedia(logo),
      qrcode: qrcode,
      mainimage: readmedia(mainimage, :label_main),
      mainimage_wide: readmedia(mainimage, :label_main_wide),
      mainimage_full: readmedia(mainimage, :label_main_full),
      background: background_image,
      border: border_image
    }
  end

  def background_image
    if background = label_params[:background].presence
      readfile(label_templates.backgrounds.fetch(background))
    end
  end

  def border_image
    if border = label_params[:border].presence
      readfile(label_templates.borders.fetch(border))
    end
  end

  def malt_lines
    lines = WordWrap.ww(fermentables, 44).split("\n")
    {
      malt1: lines[0],
      malt2: lines[1]
    }
  end

  def hop_lines
    lines = WordWrap.ww(hops, 44).split("\n")
    {
      hops1: lines[0],
      hops2: lines[1]
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

  def readmedia(file, size = :label)
    readfile(file.path(size)) if file.present?
  end

  def readfile(path)
    File.open(path, 'rb') { |file| file.read } if path.present?
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
                  :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
                  :template, :background, :border, :textcolor)
  end
end
