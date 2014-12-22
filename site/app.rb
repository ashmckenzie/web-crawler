require 'sinatra'

get '/' do
  @title = 'Index'
  erb :index
end

get '/about' do
  @title = 'About'
  erb :about
end

get '/contact' do
  @title = 'Contact'
  erb :contact
end

get '/redirected-to' do
  @title = 'Redirected To'
  erb :redirected_to
end

get '/redirect' do
  @title = 'Redirect'
  redirect to('/redirected-to')
end

get '/redirect-loop' do
  @title = 'Redirect Loop'
  redirect to('/redirect-loop')
end
