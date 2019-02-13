class HomeController

  def index
    @products = Product.order(:updated_at)
  end

  def about

  end
end