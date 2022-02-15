class Photo < Sequel::Model
  many_to_one :category
end