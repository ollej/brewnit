class CreateHops < ActiveRecord::Migration[5.1]
  def change
    create_table :hops do |t|
      t.string :name
      t.decimal :amount
      t.decimal :alpha_acid
      t.string :form
      t.string :use
      t.decimal :use_time
      t.references :recipe_detail, foreign_key: true

      t.timestamps
    end
  end
end
