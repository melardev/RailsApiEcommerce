json.success true
json.product do |json|
  json.partial! 'products/details', product: @product
  json.description @product.description
end