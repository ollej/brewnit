module PushoverConcern
  extend ActiveSupport::Concern

  included do
    after_create :notify_pushover_create
    after_destroy :notify_pushover_destroy
  end

  def notify_pushover_create
    PushMessage.new(pushover_values_create).notify
  end

  def notify_pushover_destroy
    PushMessage.new(pushover_values_destroy).notify
  end
end
