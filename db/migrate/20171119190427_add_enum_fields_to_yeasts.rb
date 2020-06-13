class AddEnumFieldsToYeasts < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE TYPE yeast_form AS ENUM
        ('Liquid', 'Dry', 'Slant', 'Culture');
    SQL
    execute <<-SQL
      CREATE TYPE yeast_type AS ENUM
        ('Ale', 'Lager', 'Wheat', 'Wine', 'Champagne');
    SQL

    remove_column :yeasts, :form
    add_column :yeasts, :form, :yeast_form, default: 'Dry', null: false
    remove_column :yeasts, :yeast_type
    add_column :yeasts, :yeast_type, :yeast_type, default: 'Ale', null: false

    change_column :yeasts, :name, :string, default: '', null: false
    change_column :yeasts, :amount, :numeric, default: 0, null: false
    change_column :yeasts, :weight, :boolean, default: true, null: false
  end

  def down
    change_column :yeasts, :form, :string, default: nil, null: true
    change_column :yeasts, :yeast_type, :string, default: nil, null: true

    change_column :yeasts, :name, :string, default: nil, null: true
    change_column :yeasts, :amount, :numeric, default: nil, null: true
    change_column :yeasts, :weight, :boolean, default: nil, null: true

    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE yeast_type;
    SQL
    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE yeast_form;
    SQL
  end
end
