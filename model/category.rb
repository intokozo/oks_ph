class Category < Sequel::Model
  one_to_many :photos

  def before_destroy
    photos.each(&:destroy)
  end
end