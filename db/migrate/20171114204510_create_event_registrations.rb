class CreateEventRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :event_registrations do |t|
      t.text :message, default: '', null: false
      t.references :event, foreign_key: true
      t.references :recipe, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
