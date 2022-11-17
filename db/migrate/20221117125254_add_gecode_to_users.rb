class AddGecodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :geocode, :jsonb
  end
end
