class Address < ApplicationRecord
  belongs_to :user, optional: true
  has_many :orders
  scope :random_address_id, -> {Address.find(Address.pluck(:id).shuffle.first).id}
  scope :random_address, -> {Address.find(Address.pluck(:id).shuffle.first)}
end