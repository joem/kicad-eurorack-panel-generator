require 'bigdecimal'
require 'bigdecimal/util'
require 'time'
require_relative 'render'
#TODO: Rework this to use the Param class, to ease up all the interpolation stuff!

# I'm calling a 'module' a 'part' since the word 'module' is a reserved word
# in ruby and I don't want to confuse things too much.

class KicadPcb
  class Part

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # A module has:
    # - a reference
    # - a layer (Front or Back layer)
    # - a last edition time stamp (for user info)
    # - a time stamp from the schematic
    # - a position.
    #
    # Its description includes:
    # - Text (at least reference and value)
    # - Graphic outlines
    # - Pads (with pad type, pad layers, pad size and position, net) A link to a 3D model, if exists, for the 3D viewer.

    attr_reader :time_stamp # Only set during initialize #TODO: Add an `update_timestamp` method?
    attr_accessor :description, :footprint_name, :graphic_items, :last_edition_time_stamp, :layer, :models, :pads, :position, :reference, :tags, :value
    #TODO: Maybe make some of these not have writers but need set_... methods instead, to enforce certain rules/requirements?

    #TODO: Add ability to pass a Setup object to it so it can use some defaults!
    def initialize(timestamp, part_hash = {})
      @timestamp = timestamp
      @footprint_name = part_hash[:footprint_name]
      @layer = part_hash[:layer]
      @last_edition_time_stamp = part_hash[:last_edition_time_stamp]
      @position = part_hash[:position]
      @description = part_hash[:description]
      @tags = part_hash[:tags]
      @reference = {} #TODO: Make reference be a fp_text object??
      if part_hash[:reference]
        @reference[:name] = part_hash[:reference][:name]
        @reference[:position] = part_hash[:reference][:position]
        @reference[:layer] = part_hash[:reference][:layer]
        @reference[:hide] = part_hash[:reference][:hide]
        @reference[:font_size] = part_hash[:reference][:font_size]
        @reference[:font_thickness] = part_hash[:reference][:font_thickness]
      else
        #TODO: Set default values??? Maybe from settings in the setup section somehow???
        # reference_name = REF**
        # hide = nil
      end
      @value = {} #TODO: Make value be a fp_text object??
      if part_hash[:value]
        @value[:name] = part_hash[:value][:name]
        @value[:position] = part_hash[:value][:position]
        @value[:layer] = part_hash[:value][:layer]
        @value[:hide] = part_hash[:value][:hide]
        @value[:font_size] = part_hash[:value][:font_size]
        @value[:font_thickness] = part_hash[:value][:font_thickness]
      else
        #TODO: Set default values??? Maybe from settings in the setup section somehow???
      end
      @graphic_items = part_hash[:graphic_items] || []
      @pads = part_hash[:pads] || [] #TODO: Are these part of the graphic items? Or separate?
      @models = part_hash[:models] || [] #TODO: Are these part of the graphic items? Or separate?
    end

    def to_sexpr
      output = ''
      output << "(module #{render_value(@footprint_name)} (layer #{render_value(@layer)}) (tedit #{render_value(@last_edition_time_stamp)}) (tstamp #{render_value(@timestamp)})"
      output << "\n"
      output << "  (at #{render_value(@position)})"
      output << "\n"
      if @description
        output << "  (descr #{render_value(@description)})"
        output << "\n"
      end
      if @tags
        output << "  (tags #{render_value(@tags)})"
        output << "\n"
      end
      output << "  (fp_text reference #{render_value(@reference[:name])} (at #{render_value(@reference[:position])}) (layer #{render_value(@reference[:layer])})#{prepend_space(render_value(@reference[:hide]))}"
      output << "\n"
      output << "    (effects (font (size #{render_value(@reference[:font_size])}) (thickness #{render_value(@reference[:font_thickness])})))"
      output << "\n"
      output << '  )'
      output << "\n"
      output << "  (fp_text reference #{render_value(@value[:name])} (at #{render_value(@value[:position])}) (layer #{render_value(@value[:layer])})#{prepend_space(render_value(@value[:hide]))}"
      output << "\n"
      output << "    (effects (font (size #{render_value(@value[:font_size])}) (thickness #{render_value(@value[:font_thickness])})))"
      output << "\n"
      output << '  )'
      output << "\n"
      @graphic_items.each do |graphic_item|
        #FIXME: Make it handle all sorts of things, such as:
        # (fp_line (start 3.7 -1.55) (end -1.15 -1.55) (layer F.CrtYd) (width 0.05))
        # (fp_circle (center 1.27 0) (end 2.17 0) (layer F.Fab) (width 0.1))
        #TODO: Or just make it do #to_sexpr
      end
      @pads.each do |pad|
        #FIXME: Make it handle all sorts of things, such as:
        # (pad 2 thru_hole circle (at 2.54 0) (size 1.8 1.8) (drill 0.9) (layers *.Cu *.Mask))
        # (pad 1 thru_hole rect (at 0 0) (size 1.8 1.8) (drill 0.9) (layers *.Cu *.Mask))
        #TODO: Or just make it do #to_sexpr
      end
      @models.each do |model|
        #FIXME: Make it handle all sorts of things, such as:
        # (model ${KISYS3DMOD}/LED_THT.3dshapes/LED_D1.8mm_W3.3mm_H2.4mm.wrl
        #   (at (xyz 0 0 0))
        #   (scale (xyz 1 1 1))
        #   (rotate (xyz 0 0 0))
        # )
        #TODO: Or just make it do #to_sexpr
      end
      output << ')'
      return output
    end

    private

    def prepend_space(param)
      if param
        " #{param}"
      else
        ''
      end
    end

  end
end


# Below is a blank module/footprint. It was made by creating a new footprint in the footprint editor then saving the footprint.
# Use it as a reference for what to use as the base Part model.

#     (module blankjoe (layer F.Cu) (tedit 5FC86B47)
#       (fp_text reference REF** (at 0 0.5) (layer F.SilkS)
#         (effects (font (size 1 1) (thickness 0.15)))
#       )
#       (fp_text value blankjoe (at 0 -0.5) (layer F.Fab)
#         (effects (font (size 1 1) (thickness 0.15)))
#       )
#     )


