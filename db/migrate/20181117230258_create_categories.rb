class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :slug, unique: true
      t.timestamps
    end

    add_index :categories, :slug, unique: true

    create_table :products_categories, id: false do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :category, index: true, foreign_key: true
    end
  end
end
