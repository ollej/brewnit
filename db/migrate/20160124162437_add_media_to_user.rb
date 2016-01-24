class AddMediaToUser < ActiveRecord::Migration
  def change
    add_reference :users, :media_avatar, references: :media, index: true
    add_foreign_key :users, :media, column: :media_avatar_id
    add_reference :users, :media_brewery, references: :media, index: true
    add_foreign_key :users, :media, column: :media_brewery_id
  end
end
