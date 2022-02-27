class Photo < Sequel::Model
  mount_uploader :file, PhotoUploader
  many_to_one :category
end
