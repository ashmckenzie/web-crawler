require 'uri'

module Crawler
  class BasicURI

    attr_reader :scheme, :host, :port, :path
    attr_writer :should_crawl

    DEFAULT_PORT   = 80
    DEFAULT_SCHEME = 'http'
    DEFAULT_PATH   = '/'

    def initialize host, path, port=DEFAULT_PORT, scheme=DEFAULT_SCHEME, should_crawl=true
      @host         = host
      @path         = path
      @port         = port.to_i
      @scheme       = scheme
      @should_crawl = should_crawl
    end

    def to_s
      @to_s ||= "#{scheme}://#{host}:#{port}#{path}"
    end

    def should_crawl?
      @should_crawl
    end

    def self.from_str str, default_scheme, default_host, default_port, should_crawl=true
      result = str.match(/^(?<scheme>(http(?:s)?))?(?:\:\/\/)?(?<host>[^\/:]*)?:?(?<port>\d*)?(?<path>\/?.*)$/)

      if result
        host    = !result['host'].empty? ? result['host'] : default_host
        path    = !result['path'].empty? ? result['path'] : DEFAULT_PATH
        port    = !result['port'].empty? ? result['port'].to_i : default_port
        scheme  = !result['scheme'].nil? ? result['scheme'] : default_scheme

        self.new(host, path, port, scheme, should_crawl)
      else
        nil
      end
    end
  end
end
