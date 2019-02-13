class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true, null: true
      t.references :product, foreign_key: true
      t.references :user, foreign_key: true
      t.string :name
      t.string :slug
      t.float :price
      t.integer :quantity
      t.timestamps
    end
  end
end
