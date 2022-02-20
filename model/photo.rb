class Photo < Sequel::Model
  many_to_one :category
  def before_destroy
    File.delete(self.link)
  end

  def url
    link.split('/').last(3).join('/')
  end
end