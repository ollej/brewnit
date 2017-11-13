class AddRegistrationFieldsToEvent < ActiveRecord::Migration[5.1]
  def change
    change_table :events do |t|
      t.text :registration_information, default: '', null: false
      t.text :address, default: '', null: false
      t.string :coordinates, default: '', null: false
      t.string :contact_email, default: '', null: false
    end
  end
end
