json.extract! product, :id, :content_type, :name, :price, :publish_on, :stock, :slug, :created_at, :updated_at
json.image_urls product.images.collect {|r| r.file_path}
json.comments do
  json.array! product.comments, partial: 'comments/comment', as: :comment
end
json.url product_url(product, format: :json)