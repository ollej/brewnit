class AddMoreFieldsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :presentation, :text
    add_column :users, :location, :string
    add_column :users, :brewery, :string
    add_column :users, :twitter, :string
    add_column :users, :url, :string
    add_column :users, :equipment, :string
  end
end
