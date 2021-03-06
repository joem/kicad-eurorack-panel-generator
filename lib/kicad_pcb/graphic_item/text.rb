require 'forwardable'
require_relative '../render'
require_relative '../param'

class KicadPcb
  class GraphicItem
    class Text

      extend Forwardable # needed for the #def_delegators forwarding
      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      attr_reader :text, :at, :layer, :tstamp, :text_size, :thickness, :justify, :graphic_item_type

      # Forward some Hash and Enumerable methods straight to the hash
      def_delegators :to_h, :[], :each, :include?, :key?, :keys, :length, :size

      def initialize(text_hash = {})
        @text = Param[text_hash[:text]]
        @at = Param[text_hash[:at] || [nil,nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @layer = Param[text_hash[:layer]]
        @tstamp = Param.new_and_ensure_really_empty_if_empty(text_hash[:tstamp])
        @text_size = Param[text_hash[:size] || text_hash[:text_size] || [nil,nil]] # Ensure array if nothing passed
        @thickness = Param[text_hash[:thickness]]
        @justify = Param.new_and_ensure_really_empty_if_empty(text_hash[:justify])
        @graphic_item_type = text_hash[:graphic_item_type] # Not a param that needs rendering, so don't make it a Param
      end

      def to_sexpr
        optional_tstamp = ''
        unless @tstamp.to_s.empty?
          optional_tstamp = " (tstamp #{@tstamp})"
        end
        optional_justify = ''
        unless @justify.to_s.empty?
          optional_justify = " (justify #{@justify})"
        end
        output = ''
        output << "(gr_text #{@text} (at #{@at}) (layer #{@layer})#{optional_tstamp}"
        output << "\n"
        output << "  (effects (font (size #{@text_size}) (thickness #{@thickness}))#{optional_justify})"
        output << "\n"
        output << ")"
        return output
      end

      def to_h
        {
          graphic_item_type: @graphic_item_type, # no need to do #to_s on this
          text: @text.to_s,
          at: @at.to_a,
          layer: @layer.to_s,
          tstamp: @tstamp.to_s,
          size: @text_size.to_a,
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

