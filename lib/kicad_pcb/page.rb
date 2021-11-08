# require_relative 'render'
require_relative 'param'

class KicadPcb
  class Page

    # include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize(page = 'A4')
      @page = Param[page]
    end

    def to_sexpr
      "(page #{@page})"
    end

  end
end
