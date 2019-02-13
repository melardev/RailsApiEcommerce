class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :content, presence: true, allow_blank: false, length: {minimum: 1, maximum: 280}
end
