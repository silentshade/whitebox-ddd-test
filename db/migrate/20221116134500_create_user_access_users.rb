class CreateUserAccessUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_access_users do |t|
      ## Database authenticatable
      t.string :identifier,  null: false
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end

    add_index :user_access_users, :identifier, unique: true
    add_index :user_access_users, :email, unique: true

  end
end
