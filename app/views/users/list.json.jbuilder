json.success true
json.data do |json|
  json.meta @dto.page_meta, partial: 'meta/page_meta', as: :page_meta
  json.users do |json|
    json.array! @dto.users, partial: 'basic_info', as: :user
  end
end
