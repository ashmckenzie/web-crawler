require 'thread'
require 'thwait'

module Crawler
  class Manager

    def initialize uri, filters=[]
      @starting_uri = uri
      @filters = filters

      @seen_uris = {}
      @jobs = []
      @lock = Mutex.new
    end

    def crawl! max_depth=3
      crawl([ starting_uri ] + starting_uri.uris, max_depth)
      ThreadsWait.all_waits(jobs) { print '.' }

      @seen_uris
    end

    private

      attr_reader :starting_uri, :filters, :lock
      attr_accessor :seen_uris, :jobs

      def crawl uris, max_depth, depth=1
        uris.each do |uri|
          next if !uri.should_crawl? || seen_uris[uri.to_s] || filters.detect { |f| !f.match?(uri.host) }

          lock.synchronize do
            seen_uris[uri.to_s] = Time.now.to_i #uri
          end

          if (depth <= max_depth)
            jobs << Thread.new { crawl(uri.uris, max_depth, depth + 1) }
          end
        end
      end

  end
end
