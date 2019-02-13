class CategoryImage < FileUpload
  default_scope {where(type: name)}
  belongs_to :category
end