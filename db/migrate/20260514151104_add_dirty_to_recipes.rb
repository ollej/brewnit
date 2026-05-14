class AddDirtyToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_column :recipe_details, :dirty, :boolean, default: false, null: false
  end
end
