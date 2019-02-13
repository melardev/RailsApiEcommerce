class Order < ApplicationRecord
  enum order_status: [:processed, :delivered, :shipped]

  has_many :order_items, dependent: :destroy # order_id in join table

  # validates :credit_card, presence: true
  belongs_to :user, optional: true # user_id column on orders table, guest users may make an order
  belongs_to :address # should point to an address

  # This is useful for seeding, when I created Orders, then I needed to seed OrderItems I should retrieve
  # Orders with no orderItems associated just yet. In production is useful as well to check if something went wrong
  # because it should not be there any order with empty order items array
  # Order.left_outer_joins(:order_items).where('order_items.order_id': nil).size
  scope :get_orders_with_empty_order_items, -> {Order.includes(:order_items).where('order_items.order_id': nil)}
  scope :get_random_empty, -> {Order.where(order_items: nil)}

  # All orders which have been received
  scope :received, -> {where('received_at is not null')}

  # All orders which are currently pending acceptance/rejection
  scope :pending, -> {where(status: 'received')}

  # All ordered ordered by their ID desending
  scope :ordered, -> {order(id: :desc)}

  def add_cart_items_from_cart(cart)
    cart.cart_items.each do |item|
      item.cart_id = nil
      order_items << OrderItem.new(product: item.product, quantity: item.quantity)
    end
  end

  after_initialize :set_defaults, :if => :new_record?
  def set_defaults
    self.order_status ||= :processed
  end

end
