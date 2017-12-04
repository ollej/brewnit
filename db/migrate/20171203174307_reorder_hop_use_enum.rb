class ReorderHopUseEnum < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
    ALTER TYPE hop_use RENAME TO _old_hop_use;
    SQL

    execute <<-SQL
    CREATE TYPE hop_use AS ENUM
        ('Mash', 'First Wort', 'Boil', 'Aroma', 'Dry Hop');
    SQL

    execute <<-SQL
    ALTER TABLE hops
      ALTER COLUMN use DROP DEFAULT,
      ALTER COLUMN use
        SET DATA TYPE hop_use
        USING use::text::hop_use,
      ALTER COLUMN use SET DEFAULT 'Boil';
    SQL

    execute <<-SQL
    DROP TYPE _old_hop_use;
    SQL
  end

  def down
  end
end
