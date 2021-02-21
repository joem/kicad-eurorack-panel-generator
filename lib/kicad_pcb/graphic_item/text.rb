require_relative '../render'

class KicadPcb
  class GraphicItem
    class Text

      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      def initialize(text_hash)
      end

      def to_sexpr
      end

    end
  end
end

#  (gr_text INDEX (at 42.164 90.17) (layer F.SilkS) (tstamp 60004E1D)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text "KEEP SPACE CLEAR\nFOR POSSIBLE LEDS" (at 48.26 55.88 90) (layer Dwgs.User)
#    (effects (font (size 0.75 0.75) (thickness 0.15)))
#  )
#  (gr_text X (at 46.736 104.394) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text "PCB1: The Control Board" (at 49.022 104.902) (layer B.SilkS)
#    (effects (font (size 1.5 1.5) (thickness 0.2)) (justify mirror))
#  )
#  (gr_text LLAWN.com (at 39.624 89.408 90) (layer B.SilkS)
#    (effects (font (size 2 2) (thickness 0.3)) (justify mirror))
#  )

