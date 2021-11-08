require_relative 'param'

class KicadPcb
  class Header

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    attr_reader :version

    def initialize(header_hash = {})
      @version = Param[header_hash[:version]]
      @host_version = Param[header_hash[:host_version]]
    end

    #TODO: Should the 'pcbnew' in the host be able to change??
    #TODO: Find out if I can or should change the host to mention my ruby program?
    def set_defaults
      @version = Param['20171130']
      @host_version = Param['(5.1.2-1)-1']
    end

    def set_version(version)
      @version = Param[version]
    end

    def to_sexpr
      "(kicad_pcb (version #{@version}) (host pcbnew #{@host_version})"
    end

    def to_h
      {
        version: @version.to_s,
        host_version: @host_version.to_s
      }
    end

  end
end
