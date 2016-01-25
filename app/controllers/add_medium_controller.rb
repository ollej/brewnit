class AddMediumController < ApplicationController
  include MediaConcern

  before_action :deny_spammers!

  def create
    @parent = load_parent
    raise AuthorizationException unless current_user.can_modify?(@parent)
    @media = @parent.media.find(params[:medium_id])
    if @parent.add_medium(@media, params[:media_type])
      respond_to do |format|
        format.html { redirect_to @parent }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @parent, alert: I18n.t(:'activerecord.errors.models.media.medium_not_added') }
        format.json { head :unprocessable_entity }
      end
    end
  end

end

