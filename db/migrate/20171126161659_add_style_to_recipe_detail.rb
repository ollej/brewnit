class AddStyleToRecipeDetail < ActiveRecord::Migration[5.1]
  def change
    add_reference :recipe_details, :style, index: true, foreign_key: true, null: true
  end
end
