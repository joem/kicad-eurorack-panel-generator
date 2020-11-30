require 'bigdecimal'
require 'bigdecimal/util'
require 'erb'
require 'time'
require_relative 'part/templates'

module KicadPcb

  class Part

    attr_accessor :at_x, :at_y, :at_rotation, :tstamp, :template

    # def initialize(footprint_name:, at_x:, at_y:, at_rotation: nil)
    def initialize(footprint_name, at_x, at_y, at_rotation = nil)
      @footprint_name = footprint_name
      @template = ERB.new(TEMPLATES[footprint_name])
      @at_x = at_x.to_d.to_s('F')
      @at_y = at_y.to_d.to_s('F')
      if at_rotation
        @at_rotation = at_rotation.to_d.to_s('F')
      else
        @at_rotation = at_rotation
      end
      @tstamp = KicadPcb.current_tstamp
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



