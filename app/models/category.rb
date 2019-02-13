class Category < ApplicationRecord
  has_and_belongs_to_many :products, :join_table => :products_categories
  # scope :users_posted_on_this, ->(username) { where(products: Product.where(user: User.where(username: username))) }
  validates :name, presence: true, uniqueness: true


  # has_many :category_images, class_name: 'CategoryImage'
  has_many :images, class_name: 'CategoryImage'


  before_validation do
    self.slug ||= "#{name.to_s.parameterize}"
  end
end
