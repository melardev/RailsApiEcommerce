json.success true
json.data do |json|
  json.meta @dto.page_meta, partial: 'shared/page_meta', as: :page_meta
  json.addresses do |json|
    json.array! @dto.resources, partial: 'addresses/address', as: :address
  end
end
