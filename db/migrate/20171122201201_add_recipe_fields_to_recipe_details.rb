class AddRecipeFieldsToRecipeDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :recipe_details, :og, :numeric, null: false, default: 0
    add_column :recipe_details, :fg, :numeric, null: false, default: 0
    add_column :recipe_details, :brewed_at, :date
    add_column :recipe_details, :carbonation, :numeric, null: false, default: 0
  end
end
