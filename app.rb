require 'dotenv/load'
require 'sinatra'
require 'slim'
require 'sinatra/simple_auth'
require 'sinatra/reloader' if development?
require_relative 'db/actions_with_db'

enable :sessions
set :password, ENV['PASSWORD']
set :hpme, '/admin' # where user should be redirected after successful authentication

get '/' do
  @categories = Category.order(:priority).all
  slim :index
end

get '/login/?' do
  'login here'
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