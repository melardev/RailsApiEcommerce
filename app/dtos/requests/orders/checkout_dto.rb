class CheckoutDto < BaseRequestDto
  attr_accessor :first_name, :last_name, :card_number, :address, :country, :zip_code, :phone_number, :address_id, :cart_items,
                :errors

  def initialize(params)
    super(params)
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @card_number = params[:card_number]
    @address = params[:address]
    @city = params[:city]
    @country = params[:country]
    @phone_number = params[:phone_number]
    @zip_code = params[:zip_code]
    @address_id = params[:address_id]
    @cart_items = params[:cart_items]
    @errors = {}
  end

  def is_reusing_addr?
    not @address_id.blank?
  end

  def is_new_addr?
    @address_id.blank?
  end

  def valid?
    if is_new_addr?
      fnv = first_name_valid?
      lnv = last_name_valid?
      cityv = city_valid?
      country = country_valid?
      av = address_valid?
      zv = zip_code_valid?
      cardv = card_number_valid?
      phonev = phone_number_valid?
    else
      addv = address_id_valid?
    end
    civ = cart_items_valid?

    @errors.blank?
  end

  def last_name_valid?
    if @last_name.blank?
      add_error(:last_name, 'Last name can not be blank')
      return false
    end
    true
  end

  def zip_code_valid?
    if @zip_code.blank?
      add_error(:zip_code, 'Last name can not be blank')
      return false
    end
    true
  end

  def card_number_valid?
    if @card_number.blank?
      add_error(:card_number, 'Last name can not be blank')
      return false
    end
    true
  end

  def address_id_valid?
    if @address_id.blank?
      add_error(:address, 'Address can not be blank')
      return false
    end
    true
  end

  def phone_number_valid?
    return true
    if @phone_number.blank?
      add_error(:phone_number, 'Last name can not be blank')
      return false
    end
    true
  end

  def cart_items_valid?
    if @cart_items.blank?
      add_error(:cart_items, 'Cart Items can not be blank')
      return false
    end
    true
  end

  def first_name_valid?
    if @first_name.blank?
      add_error(:first_name, 'City can not be blank')
      return false
    end
    true
  end

  def city_valid?
    if @city.blank?
      add_error(:city, 'City can not be blank')
      return false
    end
    true
  end

  def country_valid?
    if @country.blank?
      add_error(:country, 'Country can not be blank')
      return false
    end
    true
  end

  def address_valid?
    if @address.blank?
      add_error(:password, 'Address can not be blank')
      return false
    end
    true
  end

  def add_error(symbol, message)
    if @errors.has_key?(symbol)
      @errors[symbol].append message
    else
      @errors.merge!({symbol => [message]})
    end
  end

  def get_new_addr_params
    {country: @country, city: @city, address: @address,
     first_name: @first_name, last_name: @last_name,
     zip_code: @zip_code}
  end


end