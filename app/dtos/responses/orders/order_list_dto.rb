class OrderListDto < BasePagedDto

  attr_accessor :orders

  def initialize(orders, products_count, base_path, page, page_size)
    super(orders, products_count, base_path, page, page_size)
    @orders = orders
  end
end