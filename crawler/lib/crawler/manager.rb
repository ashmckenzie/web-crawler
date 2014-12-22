module Crawler
  class Manager

    def initialize uri
      @starting_uri = uri
      @seen_uris = {}
    end

    def crawl!
      crawl(starting_uri.uris)
      @seen_uris
    end

    private

      attr_reader :starting_uri

      def crawl uris
        uris.each do |uri|
          next unless uri.should_crawl?
          unless @seen_uris[uri.to_s]
            @seen_uris[uri.to_s] = uri
            crawl(uri.uris)
          end
        end
      end

  end
end
