class AddFieldsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :last_registration, :datetime
    add_column :events, :locked, :boolean, default: false
    add_column :events, :official, :boolean, default: false
  end
end
