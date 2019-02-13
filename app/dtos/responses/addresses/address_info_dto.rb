class AddressInfoDto
  attr_accessor :id, :first_name, :last_name, :address, :city, :country, :zip_code
  def initialize(address)
    @id = address.id
    @first_name = address.first_name
    @last_name = address.last_name
    @address = address.address
    @city = address.city
    @country = address.country
    @zip_code = address.zip_code
  end
end