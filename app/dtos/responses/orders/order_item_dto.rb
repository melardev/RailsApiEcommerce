class OrderItemDto

  def initialize(order_item)
    @id = order_item.id
    # @name = order_item.name
    # @slug = order_item.slug
    @price = order_item.price
    @quantity = order_item.quantity
  end
end