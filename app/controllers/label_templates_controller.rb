class LabelTemplatesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    label_templates = LabelTemplates.new(template: params[:template])
    svg = label_templates.template(label_params)
    send_data svg, filename: label_templates.filename, type: :svg, disposition: :inline
  end

  private
  def label_params
    params.permit(:name, :description1, :description2, :description3, :description4,
                  :abv, :ibu, :ebc, :og, :fg, :brewdate, :bottlesize, :contactinfo,
                  :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
                  :template, :logo_url, :qrcode_url, :mainimage_url, :mainimage_wide_url,
                  :mainimage_full_url)
  end
end
