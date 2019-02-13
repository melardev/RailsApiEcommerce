json.success true
json.data do |json|
  json.meta @dto.page_meta, partial: 'shared/page_meta', as: :page_meta
  json.products do |json|
    json.array! @dto.products, partial: 'products/product', as: :product
  end
end
