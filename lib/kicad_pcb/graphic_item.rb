# require_relative 'render'
require_relative 'graphic_item/line'
require_relative 'graphic_item/text'
require_relative 'graphic_item/arc'
require_relative 'graphic_item/circle'

# This class exists only to initialize a specific kind of graphic item, depending on the input.

class KicadPcb
  class GraphicItem

    # include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def self.new(graphic_item_hash)
      if graphic_item_hash[:graphic_item_type].to_s == 'line'
        Line.new(graphic_item_hash)
      elsif graphic_item_hash[:graphic_item_type].to_s == 'text'
        Text.new(graphic_item_hash)
      elsif graphic_item_hash[:graphic_item_type].to_s == 'arc'
        Arc.new(graphic_item_hash)
      elsif graphic_item_hash[:graphic_item_type].to_s == 'circle'
        Circle.new(graphic_item_hash)
      end #TODO: Should there be an `else`?
    end

    # def initialize
    # end

    # def to_sexpr
    # end

  end
end

# Graphical items are text, lines, arcs, circles on copper and non copper layers, excluding tracks and vias.
# (I think dimensions should count too??)
