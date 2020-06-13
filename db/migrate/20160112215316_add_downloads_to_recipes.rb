class AddDownloadsToRecipes < ActiveRecord::Migration[4.2]
  def change
    add_column :recipes, :downloads, :integer, default: 0, null: false
  end
end
