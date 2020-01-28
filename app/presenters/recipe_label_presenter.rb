class RecipeLabelPresenter
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::AssetUrlHelper

  def initialize(recipe, qrcode_url, params)
    @recipe = recipe
    @qrcode_url = qrcode_url
    @params = params
    @user = @recipe.user
  end

  def recipe_data
    @recipe_data ||= {
      name: @recipe.name,
      abv: "#{number_with_precision(@recipe.abv, precision: 1)}%",
      ibu: number_with_precision(@recipe.ibu, precision: 0),
      ebc: number_with_precision(@recipe.color, precision: 0),
      og: format_sg(@recipe.og),
      fg: format_sg(@recipe.fg),
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

  def label_templates
    @label_templates ||= LabelTemplates.new(template_name: @params[:template] || LabelTemplates::DEFAULT)
  end

  def pdf
    LabelMaker.create(template)
  end

  def push_values
    {
      title: I18n.t(:'common.notification.label.created.title', recipe_data),
      message: I18n.t(:'common.notification.label.created.message', recipe_data),
      sound: :magic
    }
  end

  def template
    label_templates.template(@params.merge(images))
  end

  def qrcode_image
    Qrcode.new(@qrcode_url).image
  end

  def preview_svg
    label_templates.template(recipe_data).generate_svg
  end

  def logo_url
    full_asset_url_for(logo.url(:label)) if logo.present?
  end

  def mainimage_url
    full_asset_url_for(mainimage.url(:label_main)) if mainimage.present?
  end

  def mainimage_wide_url
    full_asset_url_for(mainimage.url(:label_main_wide)) if mainimage.present?
  end

  def mainimage_full_url
    full_asset_url_for(mainimage.url(:label_main_full)) if mainimage.present?
  end

  private

  def params_data
    @params.merge(images)
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

  def fermentables
    ingredients.fermentables.map { |item| item.name }.join(", ")
  end

  def hops
    ingredients.hops.map { |item| item.name }.join(", ")
  end

  def yeasts
    ingredients.yeasts.map { |item| item.name }.join(", ")
  end

  def ingredients
    @ingredients ||= IngredientList.new(@recipe).build
  end

  def qrcode
    Qrcode.new(@qrcode_url).code
  end

  def background_image
    if background = @params[:background].presence
      readfile(label_templates.backgrounds.fetch(background))
    end
  end

  def border_image
    if border = @params[:border].presence
      readfile(label_templates.borders.fetch(border))
    end
  end

  def logo
    if @user.present? && @user.media_brewery.present?
      @user.media_brewery.file
    end
  end

  def mainimage
    if @recipe.media_main.present?
      @recipe.media_main.file
    end
  end

  def readmedia(file, size = :label)
    readfile(file.path(size)) if file.present?
  end

  def readfile(path)
    File.open(path, 'rb') { |file| file.read } if path.present?
  end

  def format_sg(value)
    number_with_precision(value, precision: 3, separator: '.')
  end

  def full_url?(url)
    uri = URI.parse(url)
    uri.hostname.present? && uri.scheme.present?
  rescue URI::Error
    false
  end

  def full_asset_url_for(url)
    return url if full_url?(url)
    asset_url(url)
  end
end
