class Role < ApplicationRecord
  has_and_belongs_to_many :users , :join_table => :users_roles

  validates :name, presence: true,  uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 60 }
end
