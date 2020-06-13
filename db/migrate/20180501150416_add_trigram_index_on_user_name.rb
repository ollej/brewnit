class AddTrigramIndexOnUserName < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.connection.execute "CREATE INDEX user_name_trigram_idx ON users USING GIN(name gin_trgm_ops)"
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX user_name_trigram_idx'
  end
end
