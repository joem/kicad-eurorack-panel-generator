require 'forwardable'
require_relative '../render'
require_relative '../param'

class KicadPcb
  class GraphicItem
    class Circle

      extend Forwardable # needed for the #def_delegators forwarding
      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      attr_reader :center, :end, :layer, :width

      # Forward some Hash and Enumerable methods straight to the hash
      def_delegators :to_h, :[], :each, :include?, :key?, :keys, :length, :size

      def initialize(circle_hash = {})
        @center = Param[circle_hash[:center] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @end = Param[circle_hash[:end] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @layer = Param[circle_hash[:layer]]
        @width = Param[circle_hash[:width]]
      end

      def to_sexpr
        "(gr_circle (center #{@center}) (end #{@end}) (layer #{@layer}) (width #{@width}))"
      end

      def to_h
        {
          center: @center.to_a,
          end: @end.to_a,
          layer: @layer.to_s,
          width: @width.to_s
        }
      end

    end
  end
end

#  (gr_circle (center 46.736 94.615) (end 47.879 96.012) (layer Dwgs.User) (width 0.15))

