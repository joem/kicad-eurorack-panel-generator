require_relative '../render'

class KicadPcb
  class GraphicItem
    class Circle

      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      def initialize(circle_hash)
      end

      def to_sexpr
      end

    end
  end
end

#  (gr_circle (center 46.736 94.615) (end 47.879 96.012) (layer Dwgs.User) (width 0.15))

