class AddUserRegistrationDataField < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :registration_data, :jsonb
  end
end
