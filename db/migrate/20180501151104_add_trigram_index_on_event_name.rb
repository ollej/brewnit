class AddTrigramIndexOnEventName < ActiveRecord::Migration[5.1]
  def up
    ActiveRecord::Base.connection.execute "CREATE INDEX events_name_trigram_idx ON events USING GIN(name gin_trgm_ops)"
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX events_name_trigram_idx'
  end
end
