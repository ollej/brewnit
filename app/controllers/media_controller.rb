class MediaController < ApplicationController
  include MediaConcern
  before_action :deny_spammers!

  def create
    @parent = load_parent
    authorize_modify!(@parent)
    @media = []
    if params[:media]
      params[:media].each do |file|
        @media << @parent.create_medium(file, params[:media_type], !!params[:force])
      end
    end
    respond_to do |format|
      format.html { redirect_to @parent, notice: I18n.t(:'activerecord.attributes.media.created') }
      format.json
    end
  end

  def destroy
    @medium = Medium.find(params[:id])
    @parent = @medium.parent
    authorize_modify!(@parent)
    @medium.destroy
    if request.xhr?
      head :no_content
    else
      respond_to do |format|
        format.html { redirect_to @parent, notice: I18n.t(:'activerecord.attributes.medium.destroyed') }
        format.json { head :no_content }
      end
    end
  end
end
