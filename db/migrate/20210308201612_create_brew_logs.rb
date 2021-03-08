class CreateBrewLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :brew_logs do |t|
      t.text :description
      t.string :brewers
      t.string :equipment
      t.date :brewed_at
      t.date :bottled_at
      t.decimal :og
      t.decimal :fg
      t.decimal :preboil_og
      t.decimal :mash_ph
      t.decimal :batch_volume
      t.decimal :boil_volume
      t.decimal :fermenter_volume
      t.decimal :bottled_volume
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
