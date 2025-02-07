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
    Rails.configuration.secrets.pushover_user
  end

  def enabled?(user_key)
    user_key.present? && Rails.env.production?
  end

  def notify
    user_key = values[:user]
    Rails.logger.debug { "notify_pushover user: #{user_key} enabled? #{enabled?(user_key)} development? #{Rails.env.development?}" }
    return false unless enabled?(user_key)
    Pushover.notification(values)
    return true
  end
end
