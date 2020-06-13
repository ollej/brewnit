class AddEnumFieldsToHops < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE TYPE hop_use AS ENUM
        ('Boil', 'Dry Hop', 'Mash', 'First Wort', 'Aroma');
    SQL
    execute <<-SQL
      CREATE TYPE hop_form AS ENUM
        ('Pellet', 'Plug', 'Leaf');
    SQL

    remove_column :hops, :use
    add_column :hops, :use, :hop_use, default: 'Boil', null: false
    remove_column :hops, :form
    add_column :hops, :form, :hop_form, default: 'Leaf', null: false

    change_column :hops, :name, :string, default: '', null: false
    change_column :hops, :amount, :numeric, default: 0, null: false
    change_column :hops, :alpha_acid, :numeric, default: 0, null: false
    change_column :hops, :use_time, :numeric, default: 0, null: false
  end

  def down
    change_column :hops, :use, :string, default: nil, null: true
    change_column :hops, :form, :string, default: nil, null: true

    change_column :hops, :name, :string, default: nil, null: true
    change_column :hops, :amount, :numeric, default: nil, null: true
    change_column :hops, :alpha_acid, :numeric, default: nil, null: true
    change_column :hops, :use_time, :numeric, default: nil, null: true

    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE hop_form;
    SQL
    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE hop_use;
    SQL
  end
end
