task :site do
  system('rackup -p 9292 site/config.ru')
end

task :crawl do
  require 'pry'
  # require 'pry-byebug'
  require_relative 'crawler/lib/crawler'

  host = 'www.digitalocean.com'
  path = '/'
  port = 443
  scheme = 'https'

  # host = 'localhost'
  # path = '/'
  # port = 9292
  # scheme = 'http'

  uri     = Crawler::URI.new(host, path, port, scheme)
  manager = Crawler::Manager.new(uri, [ Crawler::Filters::RejectIfNoMatch.new(host) ])
  uris    = manager.crawl!(2)

  puts
  binding.pry
end
