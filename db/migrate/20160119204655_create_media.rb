class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :file
      t.string :caption
      t.integer :sorting
      t.references :parent, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
