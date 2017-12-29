class AddCompleteIndexOnRecipe < ActiveRecord::Migration[5.1]
  def change
    add_index :recipes, :complete
  end
end
