class AddEventIndex < ActiveRecord::Migration
  def up
    change_column_default :events, :name, ''
    change_column_default :events, :organizer, ''
    change_column_default :events, :location, ''
    change_column_default :events, :event_type, ''
    change_column_default :events, :description, ''

    # Add fulltext indices on events
    puts "-- Adding new indices on events"
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_events_on_name ON events
        USING GIN(to_tsvector('simple', coalesce(name,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_events_on_primary ON events
      USING GIN(to_tsvector('simple',
        coalesce(name,'') || ' ' ||
        coalesce(organizer,'') || ' ' ||
        coalesce(location,'') || ' ' ||
        coalesce(event_type,'') || ' ' ||
        coalesce(description,'')))
    "
  end

  def down
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_events_on_name'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_events_on_primary '
    change_column_default :events, :name, nil
    change_column_default :events, :organizer, nil
    change_column_default :events, :location, nil
    change_column_default :events, :event_type, nil
    change_column_default :events, :description, nil
  end
end
