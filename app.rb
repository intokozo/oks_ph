require 'dotenv/load'
require 'sinatra'
require 'slim'
require 'sinatra/simple_auth'
require 'sinatra/reloader' if development?
require_relative 'db/actions_with_db'

enable :sessions
set :password, ENV['PASSWORD']
set :home, '/' # where user should be redirected after successful authentication

categories = DB[:categories]

# get "/:name" do
#   use Rack::Auth::Basic, "Restricted Area" do |username, password|
#     [username, password] == ['admin', 'admin']  
#   end
#   "Hello, #{params[:name]}!"
# end

get '/' do 
  slim :index
  # categories.first[:name]
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

before '/admin/*' do
  protected!
end

get '/admin' do
  redirect '/admin/*'
end

post '/admin/categories/:id/add_image' do
  
end