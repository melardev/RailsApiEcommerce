class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.references :user, optional: true
      t.string :address
      t.string :city
      t.string :country
      t.string :first_name
      t.string :last_name
      t.string :zip_code
      t.timestamps
    end
  end
end
