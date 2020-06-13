class AddInstagramToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :instagram, :text
  end
end
