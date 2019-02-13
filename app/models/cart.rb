class Cart < ApplicationRecord

  has_many :cart_items, dependent: :destroy # cart_id column in cart_items table
  belongs_to :user # user_id column in carts table

  # scope :get_random_empty, -> {Cart.find(Cart.pluck(:id).shuffle.first)}
  scope :get_empty_cart, -> {includes(:cart_items).where(cart_items: {cart_id: nil}).first}

  def add_product(product)
    msg = "product not found" unless product = Product.find(product.id)
    current_item = cart_items.find_by(product_id: product.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = cart_items.build_cart(product, price: product.price)
    end
    current_item
  end

  def remove_product(product_id)
    product = Product.find(product_id)
    cart_item = cart_items.find_by(product_id: product.id)
    if cart_item
      CartItem.destroy(cart_item.id)
    end
  end

  def total_price
    line_items.to_a.sum {|item| item.total_price}
  end
end
