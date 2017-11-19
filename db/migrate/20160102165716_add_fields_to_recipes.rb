class AddFieldsToRecipes < ActiveRecord::Migration[4.2]
  def change
    add_column :recipes, :abv, :decimal
    add_column :recipes, :ibu, :decimal
    add_column :recipes, :og, :decimal
    add_column :recipes, :fg, :decimal
    add_column :recipes, :style_code, :string
    add_column :recipes, :style_guide, :string
    add_column :recipes, :style_name, :string
    add_column :recipes, :batch_size, :decimal
    add_column :recipes, :color, :decimal
  end
end
