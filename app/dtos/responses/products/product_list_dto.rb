class ProductListDto < BasePagedDto

  attr_accessor :products

  def initialize(products, products_count, base_path, page, page_size)
    super(products, products_count, base_path, page, page_size)
    @products = products
  end
end