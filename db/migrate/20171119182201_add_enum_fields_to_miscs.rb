class AddEnumFieldsToMiscs < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE TYPE misc_use AS ENUM
        ('Mash', 'Boil', 'Primary', 'Secondary', 'Bottling');
    SQL
    execute <<-SQL
      CREATE TYPE misc_type AS ENUM
        ('Spice', 'Fining', 'Water Agent', 'Herb', 'Flavor', 'Other');
    SQL

    remove_column :miscs, :use
    add_column :miscs, :use, :misc_use, default: 'Boil', null: false
    remove_column :miscs, :misc_type
    add_column :miscs, :misc_type, :misc_type, default: 'Other', null: false

    change_column :miscs, :name, :string, default: '', null: false
    change_column :miscs, :amount, :numeric, default: 0, null: false
    change_column :miscs, :weight, :boolean, default: true, null: false
    change_column :miscs, :use_time, :numeric, default: 0, null: false
  end

  def down
    change_column :miscs, :use, :string, default: nil, null: true
    change_column :miscs, :misc_type, :string, default: nil, null: true

    change_column :miscs, :name, :string, default: nil, null: true
    change_column :miscs, :amount, :numeric, default: nil, null: true
    change_column :miscs, :weight, :boolean, default: nil, null: true
    change_column :miscs, :use_time, :numeric, default: nil, null: true

    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE misc_type;
    SQL
    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE misc_use;
    SQL
  end
end
