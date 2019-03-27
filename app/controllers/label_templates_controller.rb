class LabelTemplatesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    label_templates = LabelTemplates.new(template: params[:template])
    svg = label_templates.template({})
    send_data svg, filename: label_templates.filename, type: :svg, disposition: :inline
  end
end
