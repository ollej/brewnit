class PagesController < ActionController::Base
  layout false

  def error_404
    render file: 'public/404.html', status: :not_found
  end
end
