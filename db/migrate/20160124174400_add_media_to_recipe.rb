class AddMediaToRecipe < ActiveRecord::Migration[4.2]
  def change
    add_reference :recipes, :media_main, references: :media, index: true
    add_foreign_key :recipes, :media, column: :media_main_id
  end
end
