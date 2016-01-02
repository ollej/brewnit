class AddIndicesToRecipe < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_recipes_on_all ON recipes USING GIN(to_tsvector('simple', name || ' ' || description || ' ' || style_name))"
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_recipes_on_style_name ON recipes USING GIN(to_tsvector('simple', style_name))"
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_users_on_name ON users USING GIN(to_tsvector('simple', name))"

    add_index :recipes, :abv
    add_index :recipes, :ibu
    add_index :recipes, :og
    add_index :recipes, :fg
    add_index :recipes, :color
    add_index :recipes, :batch_size
    add_index :recipes, :style_code
    add_index :recipes, :style_guide
    add_index :recipes, :style_name
    add_index :recipes, :created_at
    add_index :recipes, :user_id
    add_index :recipes, :public
    add_index :users, :name
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_all'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_style_name'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_name'

    remove_index :recipes, :abv
    remove_index :recipes, :ibu
    remove_index :recipes, :og
    remove_index :recipes, :fg
    remove_index :recipes, :color
    remove_index :recipes, :batch_size
    remove_index :recipes, :style_code
    remove_index :recipes, :style_guide
    remove_index :recipes, :style_name
    remove_index :recipes, :created_at
    remove_index :recipes, :user_id
    remove_index :recipes, :public
    remove_index :users, :name
  end
end
