class CreateRecipes < ActiveRecord::Migration[4.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :description
      t.text :beerxml
      t.boolean :public

      t.timestamps null: false
    end
  end
end
