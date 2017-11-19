class UpdateRecipeSearchIndex < ActiveRecord::Migration[4.2]
  def up
    # Add column
    add_column :recipes, :equipment, :string, default: ''

    # Set empty string as default on search fields
    change_column_default :recipes, :name, ''
    change_column_default :recipes, :description, ''
    change_column_default :recipes, :style_name, ''
    change_column_default :recipes, :brewer, ''
    change_column_default :users, :presentation, ''
    change_column_default :users, :brewery, ''
    change_column_default :users, :equipment, ''
    change_column_default :users, :twitter, ''

    # Drop old indices
    puts "-- Dropping old indices"
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_primary'

    # Add fulltext indices on recipes
    puts "-- Adding new indices on recipes"
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_recipes_on_primary ON recipes
      USING GIN(to_tsvector('simple',
        coalesce(name,'') || ' ' ||
        coalesce(description,'') || ' ' ||
        coalesce(style_name,'') || ' ' ||
        coalesce(equipment,'') || ' ' ||
        coalesce(brewer,'')))
    "
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_recipes_on_equipment ON recipes USING GIN(to_tsvector('simple', coalesce(equipment,'')))"

    # Add fulltext indices on users
    puts "-- Adding new indices on users"
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_users_on_equipment ON users USING GIN(to_tsvector('simple', coalesce(equipment,'')))"
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_users_on_brewery ON users USING GIN(to_tsvector('simple', coalesce(brewery,'')))"
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_primary ON users
      USING GIN(to_tsvector('simple',
        coalesce(name,'') || ' ' ||
        coalesce(presentation,'') || ' ' ||
        coalesce(equipment,'') || ' ' ||
        coalesce(brewery,'') || ' ' ||
        coalesce(twitter,'')))
    "

    # Update all recipe fields
    puts "-- Extracting recipe fields"
    Recipe.all.each do |recipe|
      recipe.extract_details
      recipe.save!
    end
    puts "-- Update null fields in recipes"
    ActiveRecord::Base.connection.execute "UPDATE recipes SET name = '' WHERE name IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE recipes SET description = '' WHERE description IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE recipes SET brewer = '' WHERE brewer IS NULL"

    # Update all user fields with default values
    puts "-- Update null fields on users"
    ActiveRecord::Base.connection.execute "UPDATE users SET name = '' WHERE name IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE users SET presentation = '' WHERE presentation IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE users SET equipment = '' WHERE equipment IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE users SET brewery = '' WHERE brewery IS NULL"
    ActiveRecord::Base.connection.execute "UPDATE users SET twitter = '' WHERE twitter IS NULL"
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_primary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_brewery'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_equipment'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_primary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_equipment'
    ActiveRecord::Base.connection.execute "CREATE INDEX fulltext_index_recipes_on_primary ON recipes USING GIN(to_tsvector('simple', name || ' ' || description || ' ' || style_name))"

    remove_column :recipes, :equipment
  end
end
