class CreateMashSteps < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE TYPE mash_type AS ENUM
        ('Infusion', 'Temperature', 'Decoction');
    SQL

    create_table :mash_steps do |t|
      t.string :name, default: '', null: false
      t.column :mash_type, :mash_type, null: false
      t.numeric :step_temperature, null: false
      t.numeric :step_time, null: false
      t.numeric :water_grain_ratio, null: true
      t.numeric :infuse_amount, null: true
      t.numeric :infuse_temperature, null: true
      t.numeric :ramp_time, null: true
      t.numeric :end_temperature, null: true
      t.numeric :decoction_amount, null: true
      t.text :description, default: '', null: false
      t.references :recipe_detail, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :mash_steps

    execute <<-SQL
      DROP TYPE mash_type;
    SQL
  end
end
