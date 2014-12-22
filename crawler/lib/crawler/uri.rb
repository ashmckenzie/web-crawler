require 'ostruct'
require 'net/http'

module Crawler
  class URI < BasicURI

    REDIRECT_MAX = 10

    def status_code
      response.code.to_i
    end

    def uris
      content.links.map do |l|
        link  = Link.new(l)
        self.class.from_str(link.href, scheme, host, port, { should_crawl: link.should_crawl? })
      end
    end

    def response
      @response ||= perform_request(host, port, path, scheme, use_ssl?)
    end

    def perform_request host, port, path, scheme, use_ssl, redirect_count=0
      if redirect_count > REDIRECT_MAX
        return OpenStruct.new(body: "Exhausted retry count (#{REDIRECT_MAX})")
      end

      req = Net::HTTP::Get.new(path)
      result = Net::HTTP.start(host, port, use_ssl: use_ssl) { |http| http.request(req) }

      case result
        when Net::HTTPSuccess
          result
        when Net::HTTPRedirection
          redirected_uri = BasicURI.from_str(result['location'])

          if redirected_uri.to_s != to_s
            perform_request(redirected_uri.host, redirected_uri.port, redirected_uri.path, redirected_uri.scheme, redirected_uri.use_ssl?, redirect_count + 1)
          else
            OpenStruct.new(body: "Found a redirect loop at '#{to_s}'")
          end
      end
    end

    def content
      @content ||= Content.new(response.body)
    end

  end
end
