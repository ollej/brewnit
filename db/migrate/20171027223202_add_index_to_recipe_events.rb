class AddIndexToRecipeEvents < ActiveRecord::Migration
  def up
    remove_index :events_recipes, [:recipe_id, :event_id]
    remove_index :events_recipes, [:event_id, :recipe_id]
    add_index :events_recipes, [:event_id, :recipe_id], unique: true
    add_index :events_recipes, [:recipe_id, :event_id], unique: true
  end

  def down
    remove_index :events_recipes, [:event_id, :recipe_id]
    remove_index :events_recipes, [:recipe_id, :event_id]
    add_index :events_recipes, [:recipe_id, :event_id]
    add_index :events_recipes, [:event_id, :recipe_id]
  end
end
