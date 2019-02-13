class TagImage < FileUpload
  default_scope {where(type: name)}
  belongs_to :tag
end