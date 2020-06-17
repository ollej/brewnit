class PushMessage
  def initialize(values)
    @values = values
  end

  def defaults
    {
      user: user,
      title: I18n.t(:'common.notification.default_title'),
      sound: :incoming
    }
  end

  def values
    defaults.merge(@values)
  end

  def user
    Rails.application.secrets.pushover_user
  end

  def enabled?
    user.present? && Rails.env.production?
  end

  def notify
    Rails.logger.debug { "notify_pushover user: #{user} enabled? #{enabled?} development? #{Rails.env.development?}" }
    return unless enabled?
    Pushover.notification(values)
  end
end
