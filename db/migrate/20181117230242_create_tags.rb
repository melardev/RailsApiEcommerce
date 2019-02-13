class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :description
      t.string :slug
      t.timestamps
    end

    add_index :tags, :slug, unique: true

    create_table :products_tags, id: false do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :tag, index: true, foreign_key: true
    end
  end
end
