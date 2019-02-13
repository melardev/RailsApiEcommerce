class OrdersController < ApplicationController
  before_action :authorize!, only: [:index, :show]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner_or_admin, only: [:show, :destroy]
  # GET /orders
  # GET /orders.json
  def index
    page = params[:page] || 1
    page_size = params[:page_size] || 8

    @orders = Order.all.includes(:user).where(user: @current_user)
    @orders = @orders.order(created_at: :desc).offset(page_size * (page - 1)).limit(page_size)
    @orders_count = @orders.count
    @dto = OrderListDto.new(@orders, @orders_count, self.request.path, page, page_size)
    render :list
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @include_order_items = true
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    checkout_dto = CheckoutDto.new(params)
    if checkout_dto.valid?
      order = Order.new user: @current_user
      if checkout_dto.is_new_addr?
        if @current_user.nil?
          address = Address.create checkout_dto.get_new_addr_params
        else
          address = @current_user.addresses.build(checkout_dto.get_new_addr_params)
        end
        # same as @current_user.addresses.build(....)
        order.address = address
        checkout_dto.cart_items.each do |ci|
          if ci[:id].nil? or ci[:quantity].nil?
            @dto = ErrorResponse.new({address_id: 'Invalid cart item entry'})
            render 'shared/errors'
          else
            product = Product.find(ci[:id])
            order.order_items.build(product: product, quantity: ci[:quantity], price: product.price)
          end
        end
        if order.save
          @dto = SingleOrderDtoResponse.new order
          render 'orders/summary'
        else
          @dto = ErrorResponse.new 'Something went wrong'
          render 'shared/errors'
        end
      elsif checkout_dto.is_reusing_addr?
        address = Address.find_by_id(checkout_dto.address_id)
        if address.nil?
          @dto = ErrorResponse.new({address_id: 'This address does not exist'})
          render 'shared/errors'
        elsif address.user != @current_user
          @dto = ErrorResponse.new('You can not use this address, it does not belong to you')
          render 'shared/errors'
        else
          order.address = address
          checkout_dto.cart_items.each do |ci|
            if ci[:id].nil? or ci[:quantity].nil?
              @dto = ErrorResponse.new({address_id: 'Invalid cart item entry'})
              render 'shared/errors'
            else
              product = Product.find(ci[:id])
              order.order_items.build(product: product, quantity: ci[:quantity], price: product.price)
            end
          end

          if order.save
            @dto = SingleOrderDtoResponse.new order
            render 'orders/summary'
          else
            @dto = ErrorResponse.new 'Something went wrong'
            render 'shared/errors'
          end
        end
      end
    else
      @dto = ErrorResponse.new checkout_dto.get_errors
      render 'shared/errors'
    end
  end


  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html {redirect_to @order, notice: 'Order was successfully updated.'}
        format.json {render :show, status: :ok, location: @order}
      else
        format.html {render :edit}
        format.json {render json: @order.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html {redirect_to orders_url, notice: 'Order was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:address, :city, :country, :delivered, :zip_code, :user_id)
  end

  def ensure_owner_or_admin
    if not @order.nil? and ( (@order.user and @order.user == @current_user) || @current_user.is_admin?)
    else
      render_error('Permission denied, the order either does not exist or you do not own it')
    end
  end
end
