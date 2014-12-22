module Crawler
  module Filters
    class RejectIfNoMatch

      def initialize pattern
        @patterh = pattern
      end

      def regex
        @regex ||= Regexp.new(%Q{#{pattern}})
      end

      def reject? str
        !regex.match(str)
      end

      private

        attr_reader :pattern

    end
  end
end
