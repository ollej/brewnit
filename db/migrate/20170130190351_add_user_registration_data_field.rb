class AddUserRegistrationDataField < ActiveRecord::Migration
  def change
    add_column :users, :registration_data, :jsonb
  end
end
