json.extract! order, :id, :created_at, :order_status, :tracking_number, :updated_at
json.address do
  json.extract! order.address, :address, :city, :country, :zip_code, :user_id
end
if defined? @include_order_items and @include_order_items == true
  json.order_items do |json|
    json.array! order.order_items, partial: 'order_items/order_item', as: :order_item
  end
end
json.url order_url(order, format: :json)
