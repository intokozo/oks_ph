require 'dotenv/load'
require 'sinatra'
require 'slim'
require 'sinatra/simple_auth'
require 'sinatra/reloader' if development?
require_relative 'uploaders/photo_uploader'
require_relative 'db/actions_with_db'

enable :sessions
set :password, ENV['PASSWORD']
set :home, '/admin' # where user should be redirected after successful authentication

get '/' do
  @settings = Setting.last
  redirect '/admin' if @settings.nil?

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

post '/admin/edit_category/:id' do
  @category = Category.find(id: params[:id])
  @category.update(
    name: params[:name],
    priority: params[:priority]
  )
  redirect '/admin'
end

post '/admin/delete_category/:id' do
  Category.find(id: params[:id]).destroy
  redirect '/admin'
end

post '/admin/update_photos' do
  params.each do |param|
    next if param[0] == 'category_id'

    photo_params = param[1]
    Photo.find(id: photo_params[:id]).update(priority: photo_params[:priority])
  end

  redirect "/admin/category/#{params[:category_id]}"
end

post '/admin/category/:category_id/delete_photo/:id' do
  @photo = Photo.find(id: params[:id])
  @photo.destroy
  redirect "/admin/category/#{params[:category_id]}"
end

post "/admin/category/:id/add_photo" do
  if params[:photo].present?
    params[:photo].each do |photo|
      Photo.create(
        category_id: params[:id],
        file: photo[:tempfile]
      )
    end
  end
  redirect "/admin/category/#{params[:id]}"
end

post '/admin/preferences' do
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

post '/admin/ava_upload' do
  unless params[:avatar] && params[:avatar][:tempfile]
    @error = "No file selected"
    redirect '/admin'
  end
  upload_ava(params[:avatar][:tempfile])
  redirect '/admin'
end

post '/admin/create_category' do
  Category.create(
    name: params[:category_title],
    priority: params[:category_priority]
  )
  redirect '/admin'
end

not_found do
  'This is nowhere to be found.'
end

before '/admin/?' do
  protected!
end

before '/admin/*' do
  protected!
end
