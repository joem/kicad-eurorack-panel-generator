require 'forwardable'
require_relative '../render'
require_relative '../param'

class KicadPcb
  class GraphicItem
    class Line

      extend Forwardable # needed for the #def_delegators forwarding
      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      attr_reader :start, :end, :layer, :width, :tstamp

      # Forward some Hash and Enumerable methods straight to the hash
      def_delegators :to_h, :[], :each, :include?, :key?, :keys, :length, :size

      def initialize(line_hash)
        @start = Param[line_hash[:start]] #TODO: Enforce this is a 2 value array
        @end = Param[line_hash[:end]] #TODO: Enforce this is a 2 value array
        @layer = Param[line_hash[:layer]]
        @width = Param[line_hash[:width]]
        @tstamp = Param[line_hash[:tstamp]]
      end

      def to_sexpr
        optional_tstamp = ''
        if @tstamp
          optional_tstamp = " (tstamp #{@tstamp})"
        end
        "(gr_line (start #{@start}) (end #{@end}) (layer #{@layer}) (width #{@width})#{optional_timestamp})"
      end

      def to_h
        {
          start: @start.map(&:to_s),
          end: @end.map(&:to_s),
          layer: @layer.to_s,
          width: @width.to_s,
          tstamp: @tstamp.to_s
        }
      end

    end
  end
end


#  (gr_line (start 23.114 57.658) (end 73.66 57.658) (layer Dwgs.User) (width 0.15) (tstamp 6000FF7D))
#  (gr_line (start 35.306 63.754) (end 38.354 63.754) (layer B.SilkS) (width 0.12) (tstamp 60004BE8))
#  (gr_line (start 35.306 69.088) (end 35.306 63.754) (layer B.SilkS) (width 0.12))


