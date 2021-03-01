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

      def initialize(line_hash = {})
        @start = Param[line_hash[:start] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @end = Param[line_hash[:end] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @layer = Param[line_hash[:layer]]
        @width = Param[line_hash[:width]]
        @tstamp = Param.new_and_ensure_really_empty_if_empty(line_hash[:tstamp])
      end

      def to_sexpr
        optional_tstamp = ''
        unless @tstamp.to_s.empty?
          optional_tstamp = " (tstamp #{@tstamp})"
        end
        "(gr_line (start #{@start}) (end #{@end}) (layer #{@layer}) (width #{@width})#{optional_tstamp})"
      end

      def to_h
        {
          start: @start.to_a,
          end: @end.to_a,
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


