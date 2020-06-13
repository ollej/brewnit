class RemoveUsersAvatarField < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :avatar
  end
end
