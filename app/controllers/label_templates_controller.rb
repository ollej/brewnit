class LabelTemplatesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    svg = label_templates.template(label_params.merge(images))
    send_data svg, filename: label_templates.filename, type: :svg, disposition: :inline
  end

  private
  def label_templates
    @label_templates ||= LabelTemplates.new(template: params[:template])
  end

  def images
    {
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

  def readfile(path)
    File.open(path, 'rb') { |file| file.read } if path.present?
  end

  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4,
                  :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo,
                  :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
                  :template, :background, :border, :logo_url, :qrcode_url,
                  :mainimage_url, :mainimage_wide_url, :mainimage_full_url)
  end
end
