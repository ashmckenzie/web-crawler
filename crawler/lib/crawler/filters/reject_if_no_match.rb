module Crawler
  module Filters
    class RejectIfNoMatch

      def initialize pattern
        @pattern = pattern
      end

      def match? str
        !!regex.match(str)
      end

      private

        attr_reader :pattern

        def regex
          @regex ||= Regexp.new(pattern)
        end

    end
  end
end
