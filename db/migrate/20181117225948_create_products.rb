class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :content_type, default: 0
      t.text :description
      t.string :name
      t.float :price
      t.datetime :publish_on
      t.integer :stock
      t.string :slug, index: true

      t.timestamps
    end
  end
end
