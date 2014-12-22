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
end
