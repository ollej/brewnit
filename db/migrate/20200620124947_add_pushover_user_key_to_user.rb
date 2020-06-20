class AddPushoverUserKeyToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pushover_user_key, :string
  end
end
