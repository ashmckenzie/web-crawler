task :site do
  system('rackup -p 9292 site/config.ru')
end

task :crawl do
  require 'pry'
  require_relative 'crawler/lib/crawler'

  uri     = Crawler::URI.new('localhost', '/', 9292)
  manager = Crawler::Manager.new(uri)
  uris    = manager.crawl!

  binding.pry
end
