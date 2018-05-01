class CreateRecipeNameTrigramIndex < ActiveRecord::Migration[5.1]
  def up
    enable_extension :pg_trgm
    ActiveRecord::Base.connection.execute "CREATE INDEX recipe_names_trigram_idx ON recipes USING GIN(name gin_trgm_ops)"
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX recipe_names_trigram_idx'
    disable_extension :pg_trgm
  end
end
