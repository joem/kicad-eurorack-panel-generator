require_relative '../render'

class KicadPcb
  class GraphicItem
    class Arc

      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      def initialize(arc_hash)
      end

      def to_sexpr
      end

    end
  end
end



