require 'ostruct'
require 'net/http'

module Crawler
  class Link

    def initialize doc
      @doc = doc
    end

    def href
      doc.attributes['href'].to_s
    end

    def should_crawl?
      doc.attributes['rel'].to_s.downcase != 'nofollow'
    end

    private

      attr_reader :doc

  end

  class URI < BasicURI

    RETRY_MAX = 10

    def status_code
      response.code.to_i
    end

    def uris
      content.links.map do |l|
        link  = Link.new(l)
        uri   = self.class.from_str(link.href, scheme, host, port)

        if uri
          uri.should_crawl = link.should_crawl? && uri.host != 'www.google.com'
          uri
        else
          nil
        end
      end.compact
    end

    def response
      @response ||= perform_request(host, port, path, scheme)
    end

    def perform_request host, port, path, scheme, redirect_count=0
      if redirect_count > RETRY_MAX
        OpenStruct.new(body: "Exhausted retry count (#{RETRY_MAX})")
      end

      req = Net::HTTP::Get.new(path)
      result = Net::HTTP.start(host, port) { |http| http.request(req) }

      case result
        when Net::HTTPSuccess
          result
        when Net::HTTPRedirection
          redirected_uri = BasicURI.from_str(result['location'], scheme, host, port)

          if redirected_uri.to_s != to_s
            perform_request(redirected_uri.host, redirected_uri.port, redirected_uri.path, redirected_uri.scheme, redirect_count + 1)
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
