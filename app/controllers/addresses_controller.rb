class AddressesController < ApplicationController

  before_action :authorize!

  def my_addresses
    page = params[:page] || 1
    page_size = params[:page_size] || 8

    addresses = Address.includes(:user).where(user: @current_user)
    addresses = addresses.order(created_at: :desc).offset(page_size * (page - 1)).limit(page_size)
    addresses_count = addresses.count
    @dto = PagedResponse.new(addresses, addresses_count, self.request.path, page, page_size)
    render 'addresses/list'
  end
end
