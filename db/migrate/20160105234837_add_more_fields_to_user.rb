class AddMoreFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :presentation, :text
    add_column :users, :location, :string
    add_column :users, :brewery, :string
    add_column :users, :twitter, :string
    add_column :users, :url, :string
  end
end
