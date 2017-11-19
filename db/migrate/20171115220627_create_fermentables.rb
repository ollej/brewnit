class CreateFermentables < ActiveRecord::Migration[5.1]
  def change
    create_table :fermentables do |t|
      t.string :name
      t.decimal :amount
      t.decimal :yield
      t.decimal :potential
      t.decimal :ebc
      t.boolean :after_boil
      t.boolean :fermentable
      t.string :grain_type
      t.references :recipe_detail, foreign_key: true

      t.timestamps
    end
  end
end
