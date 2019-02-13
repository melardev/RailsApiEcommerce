# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :first_name
      t.string :last_name
      t.string :username, null: false
      t.string :email, null: false, default: ""
      # This field has to be named password_digest explicitly in order to has_secure_password to work
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
