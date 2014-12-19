require 'sinatra'

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

get '/contact' do
  erb :contact
end

get '/redirected-to' do
  erb :redirected_to
end

get '/redirect' do
  redirect to('/redirected-to')
end

get '/redirect-loop' do
  redirect to('/redirect-loop')
end
