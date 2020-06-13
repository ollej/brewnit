class AddReceiveEmailToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_email, :boolean, default: false
  end
end
