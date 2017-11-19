class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :organizer
      t.string :location
      t.date :held_at
      t.string :event_type
      t.string :url
      t.integer :user_id, index: true

      t.timestamps null: false
    end
  end
end
