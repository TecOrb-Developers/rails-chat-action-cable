class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :country_code
      t.string :mobile_number
      t.string :password_digest
      t.string :govt_id
      t.string :email
      t.datetime :dob
      t.bigint :referred_user_id

      t.timestamps
    end
  end
end
