require_relative 'net'
require_relative 'render'

#TODO: Don't forget about the interaction between net_classes and nets!!!!

class KicadPcb
  class Nets

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize
    end

    def to_sexpr
    end

  end
end
