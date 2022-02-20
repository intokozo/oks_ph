def upload_photo(file)
  new_filename = set_new_name

  link = "#{settings.public_folder}/img/photos/#{new_filename}"
  File.open(link, 'wb') do |f|
    f.write(file.read)
  end
  link
end

def upload_ava(file)
  File.open("#{settings.public_folder}/img/ava.jpeg", 'wb') do |f|
    f.write(file.read)
  end
end

def set_new_name
  i = 1
  directory = Dir.open("#{settings.public_folder}/img/photos")
  new_name = 'photo'
  ext = '.jpeg'

  if directory.include?(new_name + ext)
    set_name = new_name
    while directory.include?(set_name + ext)
      set_name = new_name + '_' + i.to_s
      i += 1
    end
    new_name = set_name
  end

  new_name + ext
end