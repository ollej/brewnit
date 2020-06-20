class AddNativeNotificationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :native_notifications, :boolean, default: true
  end
end
