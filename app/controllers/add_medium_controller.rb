class AddMediumController < ApplicationController
  include MediaConcern
  before_action :deny_spammers!

  def create
    @parent = load_parent
    raise AuthorizationException unless current_user.can_modify?(@parent)
    if add_medium(@parent, params[:media_type], @parent.media.find(params[:medium_id]))
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

  private

  def add_medium(resource, type, medium)
    meth = "media_#{type.underscore}".to_sym
    if has_association(resource, meth)
      resource.send("#{meth}=", medium)
      resource.save!
    else
      Rails.logger.debug { "No association found: #{meth}" }
      return false
    end
  end

  def has_association(resource, meth)
    Rails.logger.debug { meth }
    Rails.logger.debug {resource.class.reflect_on_all_associations(:belongs_to).map(&:name)}
    resource.class.reflect_on_all_associations(:belongs_to).map(&:name).include?(meth)
  end
end

