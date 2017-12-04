class AddCompleteToRecipe < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :complete, :boolean, null: false, default: false
  end
end
