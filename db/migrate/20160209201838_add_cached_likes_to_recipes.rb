class AddCachedLikesToRecipes < ActiveRecord::Migration
  def up
    add_column :recipes, :cached_votes_up, :integer, default: 0
    add_index  :recipes, :cached_votes_up
    Recipe.find_each(&:update_cached_votes)
  end

  def down
    remove_column :recipes, :cached_votes_up
  end
end
