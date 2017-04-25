class OpenSearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    respond_to do |format|
      format.xml {
        render :show, layout: false,
          content_type: 'application/opensearchdescription+xml; charset=utf-8'
      }
    end
  end
end
