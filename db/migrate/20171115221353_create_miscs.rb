class CreateMiscs < ActiveRecord::Migration[5.1]
  def change
    create_table :miscs do |t|
      t.string :name
      t.boolean :weight
      t.decimal :amount
      t.string :type
      t.string :use
      t.decimal :use_time
      t.references :recipe_detail, foreign_key: true

      t.timestamps
    end
  end
end
