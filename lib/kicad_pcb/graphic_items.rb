require 'forwardable'
require_relative 'graphic_item'
require_relative 'render'

class KicadPcb
  class GraphicItems

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@graphic_items, :[], :delete, :each, :include?, :length, :size

    def initialize(graphic_items_hash = {})
      @graphic_items = []
      # If we were passed a hash, use it to set some graphic items
      if graphic_items_hash
        graphic_items_hash.each do |_type, graphic_item_hash|
          add_graphic_item(graphic_item_hash)
        end
      end
    end

    def add_graphic_item(graphic_item_hash)
      @graphic_items << GraphicItem.new(graphic_item_hash)
    end

    # handy if you ever want to see the actual objects
    def graphic_items
      @graphic_items
    end

    # not really neaded for anything, but why not add it, I guess
    def to_a
      @graphic_items.map(&:to_h)
    end

    def to_h
      output_hash = {}
      @graphic_items.each do |graphic_item|
        output_hash[graphic_item[:graphic_item_type]] = graphic_item.to_h
      end
      return output_hash
    end

    def to_sexpr
      # output = ''
      # @graphic_items.each do |graphic_item|
      #   output << graphic_item.to_sexpr
      #   output << "\n"
      # end
      # return output
      @graphic_items.map(&:to_sexpr).join("\n")
    end

  end
end

# Graphical items are text, lines, arcs, circles on copper and non copper layers, excluding tracks and vias.
# Only text is allowed on copper layers.

#  (gr_line (start 23.114 57.658) (end 73.66 57.658) (layer Dwgs.User) (width 0.15) (tstamp 6000FF7D))
#  (gr_line (start 35.306 63.754) (end 38.354 63.754) (layer B.SilkS) (width 0.12) (tstamp 60004BE8))
#  (gr_line (start 35.306 69.088) (end 35.306 63.754) (layer B.SilkS) (width 0.12))
#  (gr_line (start 38.354 69.088) (end 35.306 69.088) (layer B.SilkS) (width 0.12))
#  (gr_line (start 38.354 63.754) (end 38.354 69.088) (layer B.SilkS) (width 0.12))
#  (gr_line (start 36.068 63.5) (end 36.068 60.452) (layer B.SilkS) (width 0.12) (tstamp 60004BE7))
#  (gr_line (start 30.734 63.5) (end 36.068 63.5) (layer B.SilkS) (width 0.12))
#  (gr_line (start 30.734 60.452) (end 30.734 63.5) (layer B.SilkS) (width 0.12))
#  (gr_line (start 36.068 60.452) (end 30.734 60.452) (layer B.SilkS) (width 0.12))
#  (gr_line (start 65.786 77.724) (end 61.722 77.724) (layer F.SilkS) (width 0.24) (tstamp 600036D6))
#  (gr_line (start 65.786 80.264) (end 65.786 77.724) (layer F.SilkS) (width 0.24))
#  (gr_line (start 61.722 80.264) (end 65.786 80.264) (layer F.SilkS) (width 0.24))
#  (gr_line (start 61.722 77.724) (end 61.722 80.264) (layer F.SilkS) (width 0.24))
#  (gr_line (start 39.37 91.186) (end 39.37 88.9) (layer F.SilkS) (width 0.24) (tstamp 60004E14))
#  (gr_line (start 44.958 91.186) (end 39.37 91.186) (layer F.SilkS) (width 0.24) (tstamp 60004E1A))
#  (gr_line (start 44.958 88.9) (end 44.958 91.186) (layer F.SilkS) (width 0.24) (tstamp 60004E17))
#  (gr_line (start 39.37 88.9) (end 44.958 88.9) (layer F.SilkS) (width 0.24) (tstamp 60004E11))
#  (gr_line (start 56.134 104.14) (end 56.134 101.854) (layer F.SilkS) (width 0.24) (tstamp 600036C8))
#  (gr_line (start 58.674 104.14) (end 56.134 104.14) (layer F.SilkS) (width 0.24))
#  (gr_line (start 58.674 101.854) (end 58.674 104.14) (layer F.SilkS) (width 0.24))
#  (gr_line (start 56.134 101.854) (end 58.674 101.854) (layer F.SilkS) (width 0.24))
#  (gr_line (start 48.006 103.124) (end 45.466 103.124) (layer F.SilkS) (width 0.24) (tstamp 600036AA))
#  (gr_line (start 48.006 105.918) (end 48.006 103.124) (layer F.SilkS) (width 0.24))
#  (gr_line (start 45.466 105.918) (end 48.006 105.918) (layer F.SilkS) (width 0.24))
#  (gr_line (start 45.466 103.124) (end 45.466 105.918) (layer F.SilkS) (width 0.24))
#  (gr_line (start 41.402 62.992) (end 41.402 60.706) (layer F.SilkS) (width 0.24) (tstamp 60003686))
#  (gr_line (start 44.958 62.992) (end 41.402 62.992) (layer F.SilkS) (width 0.24))
#  (gr_line (start 44.958 60.706) (end 44.958 62.992) (layer F.SilkS) (width 0.24))
#  (gr_line (start 41.402 60.706) (end 44.958 60.706) (layer F.SilkS) (width 0.24))
#  (gr_line (start 46.482 74.422) (end 46.482 72.136) (layer F.SilkS) (width 0.24) (tstamp 60003681))
#  (gr_line (start 51.816 74.422) (end 46.482 74.422) (layer F.SilkS) (width 0.24))
#  (gr_line (start 51.816 72.136) (end 51.816 74.422) (layer F.SilkS) (width 0.24))
#  (gr_line (start 46.482 72.136) (end 51.816 72.136) (layer F.SilkS) (width 0.24))
#  (gr_line (start 67.056 49.784) (end 62.738 49.784) (layer F.SilkS) (width 0.24) (tstamp 6000365D))
#  (gr_line (start 67.056 52.07) (end 67.056 49.784) (layer F.SilkS) (width 0.24))
#  (gr_line (start 62.738 52.07) (end 67.056 52.07) (layer F.SilkS) (width 0.24))
#  (gr_line (start 62.738 49.784) (end 62.738 52.07) (layer F.SilkS) (width 0.24))
#  (gr_line (start 41.91 46.99) (end 41.91 44.45) (layer F.SilkS) (width 0.24) (tstamp 60003617))
#  (gr_line (start 44.196 46.99) (end 41.91 46.99) (layer F.SilkS) (width 0.24))
#  (gr_line (start 44.196 44.45) (end 44.196 46.99) (layer F.SilkS) (width 0.24))
#  (gr_line (start 41.91 44.45) (end 44.196 44.45) (layer F.SilkS) (width 0.24))
#  (gr_line (start 59.436 30.734) (end 59.436 27.94) (layer F.SilkS) (width 0.24) (tstamp 600035F3))
#  (gr_line (start 61.976 30.734) (end 59.436 30.734) (layer F.SilkS) (width 0.24))
#  (gr_line (start 61.976 27.94) (end 61.976 30.734) (layer F.SilkS) (width 0.24))
#  (gr_line (start 59.436 27.94) (end 61.976 27.94) (layer F.SilkS) (width 0.24))
#  (gr_line (start 41.656 29.972) (end 41.656 27.686) (layer F.SilkS) (width 0.24) (tstamp 600035F2))
#  (gr_line (start 45.212 29.972) (end 41.656 29.972) (layer F.SilkS) (width 0.24))
#  (gr_line (start 45.212 27.686) (end 45.212 29.972) (layer F.SilkS) (width 0.24))
#  (gr_line (start 41.656 27.686) (end 45.212 27.686) (layer F.SilkS) (width 0.24))
#  (gr_text IDX (at 43.18 61.976) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text INDEX (at 42.164 90.17) (layer F.SilkS) (tstamp 60004E1D)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text X (at 46.736 104.394) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text "ARD RST" (at 56.642 106.172) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text OPTIONAL (at 61.722 110.744 90) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text Y (at 57.404 103.124) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text MODE (at 49.022 73.406) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text TRIG (at 63.754 78.994) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text TRIG (at 65.024 51.054) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text X (at 43.18 45.72) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text Y (at 60.706 29.464) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text OUT (at 43.434 28.956) (layer F.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)))
#  )
#  (gr_text "V1.1 — 2021-01-13" (at 53.594 101.854) (layer B.SilkS)
#    (effects (font (size 1 1) (thickness 0.15)) (justify mirror))
#  )
#  (gr_text "PCB1: The Control Board" (at 49.022 104.902) (layer B.SilkS)
#    (effects (font (size 1.5 1.5) (thickness 0.2)) (justify mirror))
#  )
#  (gr_text LLAWN.com (at 39.624 89.408 90) (layer B.SilkS)
#    (effects (font (size 2 2) (thickness 0.3)) (justify mirror))
#  )
#  (gr_text AVM1 (at 63.881 48.641 90) (layer B.SilkS)
#    (effects (font (size 2 2) (thickness 0.3)) (justify mirror))
#  )
#  (gr_line (start 24.638 22.606) (end 75.184 22.606) (layer Dwgs.User) (width 0.15) (tstamp 5F6031F4))
#  (gr_line (start 23.114 53.848) (end 73.66 53.848) (layer Dwgs.User) (width 0.15))
#  (gr_line (start 75.499 19.939) (end 24.638 19.939) (layer Dwgs.User) (width 0.15) (tstamp 5EBEFA93))
#  (gr_line (start 27.559 107.569) (end 78.42 107.569) (layer Dwgs.User) (width 0.15) (tstamp 5EBEFA93))
#  (gr_line (start 69.911 83.82) (end 19.05 83.82) (layer Dwgs.User) (width 0.15) (tstamp 5F4BC689))
#  (gr_line (start 73.641 109.22) (end 17.78 109.22) (layer Dwgs.User) (width 0.15))
#  (dimension 37.5 (width 0.15) (layer Dwgs.User)
#    (gr_text "37.500 mm" (at 48.75 8.2) (layer Dwgs.User)
#      (effects (font (size 1 1) (thickness 0.15)) (justify mirror))
#    )
#    (feature1 (pts (xy 67.5 15) (xy 67.5 8.913579)))
#    (feature2 (pts (xy 30 15) (xy 30 8.913579)))
#    (crossbar (pts (xy 30 9.5) (xy 67.5 9.5)))
#    (arrow1a (pts (xy 67.5 9.5) (xy 66.373496 10.086421)))
#    (arrow1b (pts (xy 67.5 9.5) (xy 66.373496 8.913579)))
#    (arrow2a (pts (xy 30 9.5) (xy 31.126504 10.086421)))
#    (arrow2b (pts (xy 30 9.5) (xy 31.126504 8.913579)))
#  )
#  (gr_text ? (at 46.863 94.869) (layer Dwgs.User) (tstamp 5F4C2419)
#    (effects (font (size 2 2) (thickness 0.3)))
#  )
#  (gr_circle (center 46.736 94.615) (end 47.879 96.012) (layer Dwgs.User) (width 0.15))
#  (gr_line (start 48.768 6.096) (end 48.768 134.62) (layer Dwgs.User) (width 0.15) (tstamp 5F4B6034))
#  (gr_text "KEEP SPACE CLEAR\nFOR POSSIBLE LEDS" (at 48.26 55.88 90) (layer Cmts.User)
#    (effects (font (size 0.75 0.75) (thickness 0.15)))
#  )
#  (gr_text "KEEP SPACE CLEAR\nFOR POSSIBLE LEDS" (at 48.26 55.88 90) (layer Dwgs.User)
#    (effects (font (size 0.75 0.75) (thickness 0.15)))
#  )
#  (gr_line (start 105 -1.25) (end 105 127.274) (layer Dwgs.User) (width 0.15) (tstamp 5F4AC880))
#  (gr_line (start 67.5 115) (end 67.5 15) (layer Edge.Cuts) (width 0.1))
#  (gr_line (start 30 115) (end 67.5 115) (layer Edge.Cuts) (width 0.1))
#  (gr_line (start 30 15) (end 30 115) (layer Edge.Cuts) (width 0.1))
#  (gr_line (start 67.5 15) (end 30 15) (layer Edge.Cuts) (width 0.1))
#  (gr_line (start 67.5 -1.25) (end 67.5 127.274) (layer Dwgs.User) (width 0.15) (tstamp 5EBEFC3A))
#  (gr_line (start 29.972 0.635) (end 29.972 129.159) (layer Dwgs.User) (width 0.15) (tstamp 5EBEFC3A))
#  (gr_line (start 39.751 4.953) (end 39.751 133.477) (layer Dwgs.User) (width 0.15) (tstamp 5F4B6083))
#  (gr_line (start 57.785 5.08) (end 57.785 133.604) (layer Dwgs.User) (width 0.15) (tstamp 5EBEFBF0))
#  (gr_line (start 30 115) (end 30 15) (layer Dwgs.User) (width 0.15) (tstamp 5EBE79BB))
#  (gr_line (start 130 115) (end 30 115) (layer Dwgs.User) (width 0.15))
#  (gr_line (start 130 15) (end 130 115) (layer Dwgs.User) (width 0.15))
#  (gr_line (start 30 15) (end 130 15) (layer Dwgs.User) (width 0.15))

