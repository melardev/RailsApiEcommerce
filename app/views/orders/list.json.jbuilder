json.success true
json.data do |json|
  json.meta @dto.page_meta, partial: 'shared/page_meta', as: :page_meta
  json.orders do |json|
    json.array! @dto.orders, partial: 'orders/order', as: :order
  end
end
