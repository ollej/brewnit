class CreateRecipeDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :recipe_details do |t|
      t.decimal :batch_size
      t.decimal :boil_size
      t.decimal :boil_time
      t.decimal :grain_temp
      t.decimal :sparge_temp
      t.decimal :efficiency
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
