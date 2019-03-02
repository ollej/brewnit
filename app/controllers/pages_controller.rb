class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :deny_spammers!, only: [:show]

  def show
    template = "pages/#{params[:page]}"
    if template_exists? template
      render layout: true, template: template
    else
      raise ActionController::RoutingError.new("Page not found: #{template}")
    end
  end

  def error_404
    render layout: false, file: 'public/404.html', status: :not_found
  end
end
