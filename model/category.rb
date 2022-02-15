class Category < Sequel::Model
  one_to_many :photos
end