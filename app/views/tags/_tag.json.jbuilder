json.extract! tag,  :id, :name, :description, :created_at, :updated_at

urls = []
tag.images.each do |ti|
  urls.push ti.file_path
end
json.image_urls urls


