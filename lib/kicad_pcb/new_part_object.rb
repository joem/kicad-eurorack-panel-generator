require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

module KicadPcb

  # I'm calling a 'module' a 'part' since the word 'module' is a reserved word
  # in ruby and I don't want to confuse things too much.

  class NewPartObject

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

    attr_accessor :reference
    attr_accessor :layer
    attr_accessor :last_edition_time_stamp
    attr_accessor :schematic_time_stamp

    #TODO: Add the other accessors, including ones for the sections not included in the blank

    def initialize
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

