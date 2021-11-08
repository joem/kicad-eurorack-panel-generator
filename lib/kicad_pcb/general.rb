
require_relative 'param'

class KicadPcb
  class General

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    #TODO: Set up some kind of hash that's accessible holding the attributes?

    attr_reader :thickness
    # The other attributes are calculated with methods

    def initialize(instantiator, general_hash = {})
      @instantiator = instantiator
      @thickness = Param[general_hash[:thickness]]
      # No other params to assign since the rest are calculated
    end

    def set_defaults
      @thickness = Param['1.6']
      # No other defaults to set since the other params are calculated
    end

    def set_thickness(thickness)
      @thickness = Param[thickness]
    end

    def to_sexpr
      output = ''
      output << '(general'
      output << "\n"
      output << "  (thickness #{@thickness.to_s})"
      output << "\n"
      output << "  (drawings #{drawings.to_i})"
      output << "\n"
      output << "  (tracks #{tracks.to_i})"
      output << "\n"
      output << "  (zones #{zones.to_i})"
      output << "\n"
      output << "  (modules #{modules.to_i})"
      output << "\n"
      output << "  (nets #{nets.to_i})"
      output << "\n"
      output << ')'
      return output
    end

    def drawings
      @instantiator.instance_variable_get(:@graphic_items).size
    end

    def tracks
      @instantiator.instance_variable_get(:@tracks).size
    end

    def zones
      @instantiator.instance_variable_get(:@zones).size
    end

    def modules
      @instantiator.instance_variable_get(:@parts).size
    end

    def nets
      @instantiator.instance_variable_get(:@nets).size
    end

    def to_h
      {
        thickness: @thickness.to_s,
        drawings: drawings.to_i,
        tracks: tracks.to_i,
        zones: zones.to_i,
        modules: modules.to_i,
        nets: nets.to_i
      }
    end

  end
end





#   (general
#     (thickness 1.6)
#     (drawings 4)
#     (tracks 0)
#     (zones 0)
#     (modules 8)
#     (nets 1)
#   )

#   (general
#     (thickness 1.6)
#     (drawings 4)              # from graphic_lines (and other things???)
#     (tracks 0)                # from tracks
#     (zones 0)                 # from zones
#     (modules 8)               # from parts
#     (nets 1)                  # from nets
#   )

