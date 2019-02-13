class SingleOrderDtoResponse
  attr_accessor :id, :order_status, :order_items, :address, :tracking_number, :order_items_count, :total

  def initialize(order)
    @id = order.id
    @order_status = order.order_status
    @tracking_number = order.tracking_number
    @address = AddressInfoDto.new order.address
    @order_items = []
    @order_items_count = order.order_items.count
    @total = 0.0
    order.order_items.each do |oi|
      @order_items.append OrderItemDto.new oi
      @total += oi.price
    end
  end
end