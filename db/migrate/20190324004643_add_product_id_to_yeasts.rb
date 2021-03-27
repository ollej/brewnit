class Yeast < ActiveRecord::Migration[5.2]
  def change
    add_column :yeasts, :product_id, :text
  end
end
