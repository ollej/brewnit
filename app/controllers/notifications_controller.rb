class NotificationsController < ApplicationController
  before_action :deny_spammers!

  def create
    respond_to do |format|
      if PushMessage.new(notification).notify
        format.html { head :no_content }
        format.json { head :no_content }
      else
        format.html { head :unprocessable_entity }
        format.json { head :unprocessable_entity }
      end
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
