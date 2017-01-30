class PagesController < ActionController::Base
  layout false

  def error_404
    render body: nil, status: :not_found
  end

  def error_500
    render body: nil, status: :internal_server_error
  end
end
