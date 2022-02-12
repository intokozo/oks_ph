def upload_photo(file:, category_id:)
  filename = params[:file][:filename]
  file = params[:file][:tempfile]
  
  new_filename = set_new_name

  File.open("../public/img/photos#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
end

def set_new_name
  i = 1
  directory = Dir.open('../public/img/photos')
  new_name = 'photo'

  if directory.include?(new_name)
    set_name = new_name
    while directory.include?(set_name)
      set_name = new_name + '_' + i.to_s
      i += 1
    end
    new_name = set_name
  end

  set_name
end