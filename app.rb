require 'dotenv/load'
require 'sinatra'
require 'slim'
require 'sinatra/simple_auth'
require 'sinatra/reloader' if development?
require_relative 'db/actions_with_db'
require_relative 'uploaders/photo_uploader'

enable :sessions
set :password, ENV['PASSWORD']
set :home, '/admin' # where user should be redirected after successful authentication

get '/' do
  @admin = true if authorized?
  @categories = Category.order(:priority).all
  slim :index
end

get '/login' do
  if params[:password].nil?
    slim :login
  else
    auth!(params[:password])
  end
end

post '/logout' do
  logout!
end

get '/admin' do
  @categories = Category.order(:priority).all
  @settings = Setting.last
  slim :admin
end

get '/admin/category/:id' do
  @category = Category.find(id: params[:id])
  slim :edit_category
end

post '/edit_category/:id' do
  @category = Category.find(id: params[:id])
  @category.update(
    name: params[:name],
    priority: params[:priority]
  )
  redirect '/admin'
end

post '/update_photo/:id' do
  @photo = Photo.find(id: params[:id])
  @photo.update(
    priority: params[:priority]
  )
  redirect '/admin'
end

delete '/delete_photo/:id' do
  @photo = Photo.find(id: params[:id])
  @photo.delete
  redirect '/admin'
end

post "/category/:id/add_photo" do
  unless params[:photo] && params[:photo][:tempfile]
    @error = "No file selected"
    redirect '/admin'
  end

  link = upload_photo(params[:photo][:tempfile])

  Photo.create(
    category_id: params[:id],
    priority: params[:priority],
    link: link
  )
  redirect '/admin'
end

post '/preferences' do
  setting = Setting.empty? ? Setting.new : Setting.last
  setting.update(
    title: params[:title],
    description_title: params[:description_title],
    description: params[:description],
    telegram_link: params[:telegram_link],
    instagram_link: params[:instagram_link],
    vk_link: params[:vk_link]
  )
  redirect '/admin'
end

post '/ava_upload' do
  unless params[:avatar] && params[:avatar][:tempfile]
    @error = "No file selected"
    redirect '/admin'
  end
  upload_ava(params[:avatar][:tempfile])
  redirect '/admin'
end

post '/create_category' do
  Category.create(
    name: params[:category_title],
    priority: params[:category_priority]
  )
  redirect '/admin'
end

not_found do
  'This is nowhere to be found.'
end

after_reload do
  puts 'reloaded'
end

before '/admin/?' do
  protected!
end

post '/admin/categories/:id/add_image' do
  
end
