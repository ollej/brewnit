class NotificationsController < ApplicationController
  before_action :deny_spammers!

  def create
    PushMessage.new(notification).notify
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  def notification
    {
      user: current_user.pushover_user_key,
      title: I18n.t('brewtimer.notification.title'),
      message: params[:message],
      sound: sound,
      url: root_url
    }
  end

  def sound
    params[:type] == "done" ? "magic" : "alien"
  end
end
