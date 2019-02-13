class CartItem < ApplicationRecord

  belongs_to :order, optional: true # order_id in cart_items table, it is not needed but it makes our life easy to create queries
  belongs_to :product # product_id in cart_items table
  belongs_to :cart # cart_id in cart_items table

  validates :quantity, numericality: true

  def total_price
    product.price * quantity
  end
end
