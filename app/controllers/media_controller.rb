class MediaController < ApplicationController
  before_action :deny_spammers!

  def create
    @parent = load_parent
    raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@parent)
    @media = []
    if params[:media]
      params[:media].each do |file|
        @media << @parent.media.create(file: file)
      end
    end
    respond_to do |format|
      format.html { redirect_to @parent, notice: I18n.t(:'activerecord.attributes.media.created') }
      format.json
    end
  end

  def delete
    @medium = Medium.find(params[:id])
    @parent = @medium.parent
    raise ActiveRecord::RecordNotFound unless current_user.can_modify?(@parent)
    @medium.destroy
    respond_to do |format|
      format.html { redirect_to @parent, notice: I18n.t(:'activerecord.attributes.medium.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def load_parent
    case
      when params[:recipe_id] then Recipe.find_by_id(params[:recipe_id])
      when params[:user_id] then User.find_by_id(params[:user_id])
    end
  end
end
