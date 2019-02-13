json.success true
json.order do |json|
  json.id @dto.id
  json.order_items_count @dto.order_items_count
  json.total @dto.total
  json.address do
    json.partial! 'addresses/address', address: @dto.address
  end
  # json.partial! 'orders/order', order: @dto
end
