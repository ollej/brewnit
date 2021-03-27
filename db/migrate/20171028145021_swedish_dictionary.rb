class SwedishDictionary < ActiveRecord::Migration[4.2]
  def up
    puts '-- Adding Swedish dictionary'
    ActiveRecord::Base.connection.execute "
      CREATE TEXT SEARCH DICTIONARY swedish (
        TEMPLATE = ispell,
        DictFile = sv_se,
        AffFile = sv_se,
        Stopwords = swedish
      );
    "

    puts '-- Adding Swedish snowball dictionary'
    ActiveRecord::Base.connection.execute "
      CREATE TEXT SEARCH DICTIONARY swedish_snowball_dict (
          TEMPLATE = snowball,
          Language = swedish,
          StopWords = swedish
      );
    "
    ActiveRecord::Base.connection.execute "
      CREATE TEXT SEARCH CONFIGURATION swedish_snowball (
          PARSER = 'default'
      );
    "
    ActiveRecord::Base.connection.execute "
      ALTER TEXT SEARCH CONFIGURATION swedish_snowball
          ALTER MAPPING FOR asciiword, asciihword, hword_asciipart,
                        word, hword, hword_part
          WITH swedish, swedish_snowball_dict;
    "

    puts '-- Recreating indices for events with snowball dictionary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_events_on_name'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_events_on_primary'
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_events_on_name ON events
        USING GIN(to_tsvector('swedish_snowball', coalesce(name,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_events_on_primary ON events
      USING GIN(to_tsvector('swedish_snowball',
        coalesce(name,'') || ' ' ||
        coalesce(organizer,'') || ' ' ||
        coalesce(location,'') || ' ' ||
        coalesce(event_type,'') || ' ' ||
        coalesce(description,'')))
    "

    puts '-- Recreating indices for recipes with snowball dictionary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_primary'
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_recipes_on_primary ON recipes
      USING GIN(to_tsvector('swedish_snowball',
        coalesce(name,'') || ' ' ||
        coalesce(description,'') || ' ' ||
        coalesce(style_name,'') || ' ' ||
        coalesce(equipment,'') || ' ' ||
        coalesce(brewer,'')))
    "
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_equipment'
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_recipes_on_equipment ON recipes
        USING GIN(to_tsvector('swedish_snowball', coalesce(equipment,'')))
    "

    puts '-- Recreating indices on users with snowball dictionary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_primary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_brewery'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_equipment'
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_equipment ON users
        USING GIN(to_tsvector('swedish_snowball', coalesce(equipment,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_brewery ON users
        USING GIN(to_tsvector('swedish_snowball', coalesce(brewery,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_primary ON users
      USING GIN(to_tsvector('swedish_snowball',
        coalesce(name,'') || ' ' ||
        coalesce(presentation,'') || ' ' ||
        coalesce(equipment,'') || ' ' ||
        coalesce(brewery,'') || ' ' ||
        coalesce(twitter,'')))
    "
  end

  def down
    puts '-- Recreating indices for events'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_events_on_name'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_events_on_primary'
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

    puts '-- Recreating indices for recipes'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_primary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_recipes_on_equipment'
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_recipes_on_primary ON recipes
      USING GIN(to_tsvector('simple',
        coalesce(name,'') || ' ' ||
        coalesce(description,'') || ' ' ||
        coalesce(style_name,'') || ' ' ||
        coalesce(equipment,'') || ' ' ||
        coalesce(brewer,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_recipes_on_equipment ON recipes
        USING GIN(to_tsvector('simple', coalesce(equipment,'')))
    "

    puts '-- Recreating indices for users'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_primary'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_brewery'
    ActiveRecord::Base.connection.execute 'DROP INDEX fulltext_index_users_on_equipment'
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_equipment ON users
        USING GIN(to_tsvector('simple', coalesce(equipment,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_brewery ON users
        USING GIN(to_tsvector('simple', coalesce(brewery,'')))
    "
    ActiveRecord::Base.connection.execute "
      CREATE INDEX fulltext_index_users_on_primary ON users
      USING GIN(to_tsvector('simple',
        coalesce(name,'') || ' ' ||
        coalesce(presentation,'') || ' ' ||
        coalesce(equipment,'') || ' ' ||
        coalesce(brewery,'') || ' ' ||
        coalesce(twitter,'')))
    "

    puts '-- Dropping swedish snowball dictionary'
    ActiveRecord::Base.connection.execute "
      DROP TEXT SEARCH CONFIGURATION swedish_snowball;
    "
    ActiveRecord::Base.connection.execute "
      DROP TEXT SEARCH DICTIONARY swedish_snowball_dict;
    "
  end
end
