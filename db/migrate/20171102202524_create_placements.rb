class CreatePlacements < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE TYPE medal AS ENUM ('gold', 'silver', 'bronze');
    SQL

    create_table :placements do |t|
      t.column :medal, :medal
      t.string :category, default: ''
      t.boolean :locked, default: false
      t.references :recipe, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
    add_index :placements, :medal
  end

  def down
    drop_table :placements

    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE medal;
    SQL
  end
end
