require 'forwardable'
require_relative 'part'
require_relative 'render'
require_relative 'param'

class KicadPcb
  class Parts

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@parts, :[], :delete, :each, :include?, :key?, :keys, :length, :size

    def initialize
      @parts = {}
    end

    def add_part(part_hash = {})
      timestamp = part_hash[:timestamp] || Param.current_timestamp
      @parts[timestamp] = Part.new(timestamp, part_hash)
    end

    def to_sexpr
      output = ''
      @parts.each do |_key, part|
        output << part.to_sexpr
        output << "\n"
        output << "\n" # Put an empty line after each Part
      end
      return output
    end

  end
end


#  (net_class Default "This is the default net class."
#    (clearance 0.2)
#    (trace_width 0.25)
#    (via_dia 0.8)
#    (via_drill 0.4)
#    (uvia_dia 0.3)
#    (uvia_drill 0.1)
#  )

