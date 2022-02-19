require 'dotenv/load'
require 'sinatra'
require 'slim'
require 'sinatra/simple_auth'
require 'sinatra/reloader' if development?
require_relative 'db/actions_with_db'

enable :sessions
set :password, ENV['PASSWORD']
set :home, '/admin' # where user should be redirected after successful authentication

get '/' do
  @categories = Category.order(:priority).all
  slim :index
end

post '/login' do
  params
end

get '/login' do
  if params[:password].nil?
    slim :login
  else
    auth!(params[:password])
  end
end

get '/admin' do
  @categories = Category.all
  slim :admin
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
