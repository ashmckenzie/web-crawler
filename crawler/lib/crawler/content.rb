require 'nokogiri'

module Crawler
  class Content

    def initialize content
      @doc = Nokogiri::HTML(content)
    end

    def to_s
      doc.to_s
    end

    def title
      doc.search('title').text
    end

    def links
      doc.search('a')
    end

    def assets
      binding.pry
    end

    private

      attr_reader :default_host, :doc

  end
end
