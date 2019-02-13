class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :rating, null: true
      t.string :content
      t.references :product, foreign_key: true
      t.references :user, index: true, foreign_key: true # Rails 5, reference + index + column name in one line
      t.timestamps
    end

    # change_column :comments, :rating, :integer, :null => true
  end
end
