class CreateYeasts < ActiveRecord::Migration[5.1]
  def change
    create_table :yeasts do |t|
      t.string :name
      t.boolean :weight
      t.decimal :amount
      t.string :yeast_type
      t.string :form
      t.references :recipe_detail, foreign_key: true

      t.timestamps
    end
  end
end
