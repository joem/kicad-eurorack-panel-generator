# require_relative 'render'
require_relative 'param'

class KicadPcb
  class Page

    # include Render # Render contains #indent, #render_value, #render_array, and #render_hash
    attr_reader :page

    def initialize(page = nil)
      @page = Param[page]
    end

    #TODO: add a set_defaults method like the other classes, even if it's super simple

    def set_page(page)
      @page = Param[page]
    end

    def set_defaults
      @page = Param['A4']
    end

    def to_sexpr
      "(page #{@page})"
    end

  end
end
