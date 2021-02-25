require 'forwardable'
require_relative '../render'
require_relative '../param'

class KicadPcb
  class GraphicItem
    class Text

      extend Forwardable # needed for the #def_delegators forwarding
      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      attr_reader :text, :at, :layer, :tstamp, :size, :thickness, :justify

      # Forward some Hash and Enumerable methods straight to the hash
      def_delegators :to_h, :[], :each, :include?, :key?, :keys, :length, :size

      def initialize(text_hash)
        @text = Param[text_hash[:text]] #TODO: Enforce this is a 2-value array
        @at = Param[text_hash[:at]]
        @layer = Param[text_hash[:layer]]
        @tstamp = Param[text_hash[:tstamp]]
        @size = Param[text_hash[:size]] #TODO: Enforce this is a 2-value array
        @thickness = Param[text_hash[:thickness]]
        @justify = Param[text_hash[:justify]]
      end

      def to_sexpr
        optional_tstamp = ''
        if @tstamp
          optional_tstamp = " (tstamp #{@tstamp})"
        end
        optional_justify = ''
        if @justify
          optional_justify = " (justify #{@justify})"
        end
        output = ''
        output << "(gr_text #{@text} (at #{@at}) (layer #{@layer})#{optional_tstamp}"
        output << "\n"
        output << "  (effects (font (size #{@size}) (thickness #{@thickness}))#{optional_justify})"
        output << "\n"
        output << ")"
        return output
      end

      def to_h
        {
          text: @text.to_s,
          at: @at.map(&:to_s),
          layer: @layer.to_s,
          tstamp: @tstamp.to_s,
          size: @size.map(&:to_s),
          thickness: @thickness.to_s,
          justify: @justify.to_s
        }
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

