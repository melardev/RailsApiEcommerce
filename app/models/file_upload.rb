class FileUpload < ApplicationRecord
  belongs_to :user, optional: true
end