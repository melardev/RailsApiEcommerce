class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name, index: true
      t.string :description

      t.timestamps
    end

    create_table :users_roles, id: false do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :role, index: true, foreign_key: true
    end
  end
end
