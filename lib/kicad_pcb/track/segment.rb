require 'forwardable'
require_relative '../render'
require_relative '../param'

class KicadPcb
  class Track
    class Segment

      extend Forwardable # needed for the #def_delegators forwarding
      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      attr_reader :start, :end, :width, :layer, :net, :tstamp, :track_type

      # Forward some Hash and Enumerable methods straight to the hash
      def_delegators :to_h, :[], :each, :include?, :key?, :keys, :length, :size

      def initialize(segment_hash = {})
        @start = Param[segment_hash[:start] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @end = Param[segment_hash[:end] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @width = Param[segment_hash[:width]]
        @layer = Param[segment_hash[:layer]]
        @net = Param[segment_hash[:net]]
        @tstamp = Param.new_and_ensure_really_empty_if_empty(segment_hash[:tstamp])
        @track_type = segment_hash[:track_type] # Not a param that needs rendering, so don't make it a Param
      end

      def to_sexpr
        optional_tstamp = ''
        unless @tstamp.to_s.empty?
          optional_tstamp = " (tstamp #{@tstamp})"
        end
        "(segment (start #{@start}) (end #{@end}) (width #{@width}) (layer #{@layer}) (net #{@net})#{optional_tstamp})"
      end

      def to_h
        {
          track_type: @track_type, # no need to do #to_s on this
          start: @start.to_a,
          end: @end.to_a,
          width: @width.to_s,
          layer: @layer.to_s,
          net: @net.to_s,
          tstamp: @tstamp.to_s
        }
      end

    end
  end
end

#  (segment (start 35.433 31.369) (end 31.623 27.559) (width 1) (layer F.Cu) (net 3))
#  (segment (start 54.102 29.972) (end 44.323 29.972) (width 1) (layer F.Cu) (net 3) (tstamp 600040F6))
#  (segment (start 35.814 31.75) (end 35.433 31.369) (width 1) (layer F.Cu) (net 3))
#  (segment (start 44.323 29.972) (end 42.545 31.75) (width 1) (layer F.Cu) (net 3))
#  (segment (start 57.912 33.782) (end 54.102 29.972) (width 1) (layer F.Cu) (net 3))
#  (segment (start 42.545 31.75) (end 35.814 31.75) (width 1) (layer F.Cu) (net 3))
#  (segment (start 62.103 33.782) (end 57.912 33.782) (width 1) (layer F.Cu) (net 3))

