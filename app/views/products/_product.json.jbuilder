json.extract! product, :id, :content_type, :name, :price, :publish_on, :slug,  :created_at, :updated_at
json.comments_count product.comments.count
json.url product_url(product, format: :json)
image_urls = []
product.images.each do |image|
  image_urls.append image.file_path
end

json.image_urls image_urls

