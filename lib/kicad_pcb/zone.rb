require_relative 'render'

class KicadPcb
  class Zone

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize
    end

    def to_sexpr
    end

  end
end
