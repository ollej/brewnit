class AddTypeEnumToFermentables < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE TYPE fermentable_type AS ENUM
        ('Grain', 'Sugar', 'Extract', 'Dry Extract', 'Adjunct');
    SQL

    remove_column :fermentables, :grain_type
    add_column :fermentables, :grain_type, :fermentable_type, default: 'Grain', null: false

    change_column :fermentables, :name, :string, default: '', null: false
    change_column :fermentables, :amount, :numeric, default: 0, null: false
    change_column :fermentables, :yield, :numeric, default: 0, null: false
    change_column :fermentables, :potential, :numeric, default: 0, null: false
    change_column :fermentables, :ebc, :numeric, default: 0, null: false
    change_column :fermentables, :after_boil, :boolean, default: false, null: false
    change_column :fermentables, :fermentable, :boolean, default: true, null: false
  end

  def down
    change_column :fermentables, :grain_type, :string, default: nil

    change_column :fermentables, :name, :string, default: nil, null: true
    change_column :fermentables, :amount, :numeric, default: nil, null: true
    change_column :fermentables, :yield, :numeric, default: nil, null: true
    change_column :fermentables, :potential, :numeric, default: nil, null: true
    change_column :fermentables, :ebc, :numeric, default: nil, null: true
    change_column :fermentables, :after_boil, :boolean, default: nil, null: true
    change_column :fermentables, :fermentable, :boolean, default: nil, null: true

    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE fermentable_type;
    SQL
  end
end
