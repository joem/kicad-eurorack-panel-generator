require_relative 'graphic_item/line'
require_relative 'graphic_item/text'
require_relative 'graphic_item/arc'
require_relative 'graphic_item/circle'

# This class exists only to initialize a specific kind of graphic item, depending on the input.

class KicadPcb
  class GraphicItem

    def self.new(graphic_item_hash)
      if graphic_item_hash[:graphic_item_type].to_s == 'line'
        Line.new(graphic_item_hash)
      elsif graphic_item_hash[:graphic_item_type].to_s == 'text'
        Text.new(graphic_item_hash)
      elsif graphic_item_hash[:graphic_item_type].to_s == 'arc'
        Arc.new(graphic_item_hash)
      elsif graphic_item_hash[:graphic_item_type].to_s == 'circle'
        Circle.new(graphic_item_hash)
      else
        raise ArgumentError, 'valid graphic_item_type not specified in hash'
      end
    end

    # def initialize # Should never be used for this class.
    # end

    # def to_sexpr # Should never be used for this class.
    # end

  end
end

# Graphical items are text, lines, arcs, circles on copper and non copper layers, excluding tracks and vias.
# (I think dimensions should count too??)
