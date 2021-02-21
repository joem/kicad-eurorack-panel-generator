require_relative '../render'

class KicadPcb
  class Track
    class Segment

      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      # start 54.102 29.972
      # end 44.323 29.972
      # width 1
      # layer F.Cu
      # net 3
      # tstamp 600040F6  (optional!)

      attr_accessor :start, :end, :width, :layer, :net, :tstamp

      def initialize(segment_hash)
      end

      def to_sexpr
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

