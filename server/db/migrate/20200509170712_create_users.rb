class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name, limit: 255
      t.string :last_name, limit: 255
      t.string :username
      t.string :email
      t.string :phone_number
      t.string :date_of_birth
      t.string :password_digest

      t.timestamps
    end
  end
end
