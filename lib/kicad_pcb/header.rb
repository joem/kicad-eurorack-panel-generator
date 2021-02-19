require_relative 'render'

class KicadPcb
  class Header

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize(version = '20171130', host_version = '"(5.1.2-1)-1"')
      @version = version
      @host_version = host_version
    end

    def to_sexpr
      #TODO: Make it handle quoting of these variables if necessary (instead of relying on hardcoded quotes!)
      #        - use the methods from Render
      "(kicad_pcb (version #{@version}) (host pcbnew #{@host_version})"
    end

  end
end
