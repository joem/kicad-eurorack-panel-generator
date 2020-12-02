require 'bigdecimal'
require 'bigdecimal/util'
require 'erb'
require 'time'
require_relative 'part/templates'

module KicadPcb

  class Part

    attr_accessor :at_x, :at_y, :at_rotation, :tstamp, :template, :reference, :extra_options

    # Arguments:
    #   footprint_name
    #     The footprint_name is used to retrieve the template from the
    #     available templates. It should be a string.
    #   at_x
    #     The x position the part should be placed at.
    #   at_y
    #     The y position the part should be placed at.
    #   reference = 'REF**'
    #     The reference value that should be assigned to the part. Should be a
    #     string. If the string has spaces, the string needs to be quoted.
    #     Defaults to 'REF**' as KiCad does.
    #   at_rotation
    #     The rotation that the part should be at. Defaults to nil for no
    #     rotation.
    #   extra_options = {}
    #     A hash for any part-specific options mentioned in the template.
    #     Defaults to an empty hash.
    #
    # def initialize(footprint_name:, at_x:, at_y:, at_rotation: nil)
    def initialize(footprint_name, at_x, at_y, reference = 'REF**', at_rotation = nil, extra_options = {})
      @footprint_name = footprint_name
      @template = ERB.new(TEMPLATES[footprint_name])
      @at_x = at_x.to_d.to_s('F')
      @at_y = at_y.to_d.to_s('F')
      if at_rotation
        @at_rotation = at_rotation.to_d.to_s('F')
      else
        @at_rotation = at_rotation
      end
      @reference = reference
      @tstamp = KicadPcb.current_tstamp
      @extra_options = extra_options
    end

    def output
      @template.result(binding)
    end

    def to_s
      output
    end

    def precede_with_space(input)
      if input
        " #{input}"
      else
        nil
      end
    end

    # private


  end

end



# here's the m3 mounting hole footprint I want to use:
# - note the `(at 32.5 150.5)` -- that's the absolute center position
# - note the `locked` on the first line -- that makes the part be locked
# - note the `hide` at the end of the `fp_text reference`, `fp_text value`, and `fp_text user` lines -- that hides those values from appearing on the pcb

#   (module MountingHole:MountingHole_3.2mm_M3_DIN965 locked (layer F.Cu) (tedit 56D1B4CB) (tstamp 5FC4333A)
#     (at 32.5 150.5)
#     (descr "Mounting Hole 3.2mm, no annular, M3, DIN965")
#     (tags "mounting hole 3.2mm no annular m3 din965")
#     (attr virtual)
#     (fp_text reference REF** (at 0 -3.8) (layer F.SilkS) hide
#       (effects (font (size 1 1) (thickness 0.15)))
#     )
#     (fp_text value MountingHole_3.2mm_M3_DIN965 (at 0 3.8) (layer F.Fab) hide
#       (effects (font (size 1 1) (thickness 0.15)))
#     )
#     (fp_circle (center 0 0) (end 3.05 0) (layer F.CrtYd) (width 0.05))
#     (fp_circle (center 0 0) (end 2.8 0) (layer Cmts.User) (width 0.15))
#     (fp_text user %R (at 0.3 0) (layer F.Fab) hide
#       (effects (font (size 1 1) (thickness 0.15)))
#     )
#     (pad 1 np_thru_hole circle (at 0 0) (size 3.2 3.2) (drill 3.2) (layers *.Cu *.Mask))
#   )



