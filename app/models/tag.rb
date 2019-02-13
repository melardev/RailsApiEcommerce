class Tag < ApplicationRecord
  has_and_belongs_to_many :articles, :join_table => :products_tags

  validates :name, presence: true, uniqueness: {case_sensitive: false},
            length: {maximum: 150}

  # has_many :tag_images, class_name: 'TagImage'
  has_many :images, class_name: 'TagImage'

  before_validation do
    self.slug ||= "#{name.to_s.parameterize}"
  end
end
