class CreateFileUploads < ActiveRecord::Migration[5.2]
  def change
    # rails g model FileUpload type:integer file_path:string file_name:string original_filename:string
    # file_size:integer tag:references category:references user:references

    create_table :file_uploads do |t|
      t.string :type, null: false
      t.string :file_path
      t.string :file_name
      t.string :original_filename
      t.integer :file_size
      t.boolean :is_featured
      t.references :tag, foreign_key: true, null: true
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true, null: true

      t.timestamps
    end
  end
end
