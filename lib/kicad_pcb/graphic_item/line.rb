require_relative '../render'

class KicadPcb
  class GraphicItem
    class Line

      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      def initialize(line_hash)
      end

      def to_sexpr
      end

    end
  end
end


#  (gr_line (start 23.114 57.658) (end 73.66 57.658) (layer Dwgs.User) (width 0.15) (tstamp 6000FF7D))
#  (gr_line (start 35.306 63.754) (end 38.354 63.754) (layer B.SilkS) (width 0.12) (tstamp 60004BE8))
#  (gr_line (start 35.306 69.088) (end 35.306 63.754) (layer B.SilkS) (width 0.12))


