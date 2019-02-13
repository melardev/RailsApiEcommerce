class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true, null:true
      t.references :address, foreign_key: true
      t.string :tracking_number
      t.integer :order_status, default: 0
      t.timestamps
    end
  end
end
