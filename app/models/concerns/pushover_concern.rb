module PushoverConcern
  extend ActiveSupport::Concern

  included do
    after_create :notify_pushover_create
    after_destroy :notify_pushover_destroy
  end

  class_methods do
  end

  def pushover_user
    Rails.application.secrets.pushover_user
  end

  def pushover_enabled?
    pushover_user.present? && Rails.env.production?
  end

  def pushover_values(type = :create)
    {
      user: pushover_user,
      title: I18n.t(:'common.notification.default_title'),
      sound: 'incoming'
    }
  end

  def notify_pushover(type = :create)
    Rails.logger.debug { "notify_pushover type: #{type} user: #{pushover_user} enabled? #{pushover_enabled?} development? #{Rails.env.development?}" }
    return unless pushover_enabled?
    Pushover.notification(pushover_values(type))
  end

  def notify_pushover_create
    notify_pushover(:create)
  end

  def notify_pushover_destroy
    notify_pushover(:destroy)
  end
end
