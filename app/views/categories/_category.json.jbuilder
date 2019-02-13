json.extract! category, :id, :name, :created_at, :updated_at

urls = []
category.images.each do |ti|
  urls.push ti.file_path
end
json.image_urls urls

# json.url category_url(category, format: :json)