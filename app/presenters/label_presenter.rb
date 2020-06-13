class LabelPresenter
  include ActionView::Helpers::AssetUrlHelper

  def initialize(user, params, qrcode_url)
    @user = user
    @qrcode_url = qrcode_url
    @params = params.to_hash.symbolize_keys
  end

  def recipe_data
    {
      brewdate: I18n.l(Date.today),
      bottlesize: '50 cl',
      brewery: @user&.brewery,
      qrcode: Qrcode.new(@qrcode_url).code,
      logo: readmedia(logo),
      background: background_image,
      border: border_image
    }
  end

  def label_templates
    @label_templates ||= LabelTemplates.new(template_name: @params[:template] || LabelTemplates::DEFAULT)
  end

  def pdf
    LabelMaker.create(template)
  end

  def push_values
    {
      title: I18n.t(:'common.notification.label.created.title', @params),
      message: I18n.t(:'common.notification.label.created.message', @params),
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
    nil
  end

  def mainimage_wide_url
    nil
  end

  def mainimage_full_url
    nil
  end

  private

  def images
    {
      logo: readmedia(logo),
      qrcode: qrcode,
      background: background_image,
      border: border_image
    }
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

  def readmedia(file, size = :label)
    readfile(file.path(size)) if file.present?
  end

  def readfile(path)
    File.open(path, 'rb') { |file| file.read } if path.present?
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
