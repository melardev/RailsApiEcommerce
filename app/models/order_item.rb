class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :order_shipping_info

  validates :quantity, numericality: true


  # This allows you to add a product to the scoped order. For example Order.first.order_items.add_product(...).
  # This will either increase the quantity of the value in the order or create a new item if one does not
  # exist already.
  #
  # @param ordered_item [Object] an object which implements the Shoppe::OrderableItem protocol
  # @param quantity [Fixnum] the number of items to order
  # @return [Shoppe::OrderItem]
  def self.add_item(ordered_item, quantity = 1)
    fail Errors::UnorderableItem, ordered_item: ordered_item unless ordered_item.orderable?
    transaction do
      if existing = where(ordered_item_id: ordered_item.id, ordered_item_type: ordered_item.class.to_s).first
        existing.increase!(quantity)
        existing
      else
        new_item = create(ordered_item: ordered_item, quantity: 0)
        new_item.increase!(quantity)
        new_item
      end
    end
  end

  # Remove a product from an order. It will also ensure that the order's custom delivery
  # service is updated if appropriate.
  #
  # @return [Shoppe::OrderItem]
  def remove
    transaction do
      destroy!
      order.remove_delivery_service_if_invalid
      self
    end
  end

  # Increases the quantity of items in the order by the number provided. Will raise an error if we don't have
  # the stock to do this.
  #
  # @param quantity [Fixnum]
  def increase!(amount = 1)
    transaction do
      self.quantity += amount
      unless in_stock?
        # fail Shoppe::Errors::NotEnoughStock, ordered_item: ordered_item, requested_stock: self.quantity
      end
      save!
     # order.remove_delivery_service_if_invalid
    end
  end

  # Decreases the quantity of items in the order by the number provided.
  #
  # @param amount [Fixnum]
  def decrease!(amount = 1)
    transaction do
      self.quantity -= amount
      self.quantity == 0 ? destroy : save!
     # order.remove_delivery_service_if_invalid
    end
  end

  # The total cost for the product
  #
  # @return [BigDecimal]
  def total_cost
    quantity * product.price
  end
end
