class AddMediaToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :media_main, references: :media, index: true
    add_foreign_key :events, :media, column: :media_main_id
  end
end
