class AddBrewerToRecipe < ActiveRecord::Migration
  def up
    add_column :recipes, :brewer, :string
    add_index :recipes, :brewer
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_all'
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_recipes_on_primary ON recipes USING GIN(to_tsvector('simple', name || ' ' || description || ' ' || style_name || ' ' || brewer))"

    Recipe.all.each do |recipe|
      recipe.extract_details
      recipe.save!
    end
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_primary'
    remove_index :recipes, :brewer
    remove_column :recipes, :brewer
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_recipes_on_all ON recipes USING GIN(to_tsvector('simple', name || ' ' || description || ' ' || style_name))"
  end
end
