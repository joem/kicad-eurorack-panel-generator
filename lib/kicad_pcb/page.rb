class KicadPcb
  class Page

require_relative 'render'
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize
    end

    def to_sexpr
    end
    def initialize(page = 'A4')
      @page = page
    end

    def to_sexpr
      "(page #{@page})"
    end

  end
end