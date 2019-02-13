class ProductImage < FileUpload
  default_scope {where(type: name)}
  belongs_to :product
end
