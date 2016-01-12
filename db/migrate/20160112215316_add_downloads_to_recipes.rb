class AddDownloadsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :downloads, :integer, default: 0, null: false
  end
end
