class AddPhoneNumberToRegistrationData < ActiveRecord::Migration[5.1]
  def change
    add_column :registration_data, :phone, :string
  end
end
