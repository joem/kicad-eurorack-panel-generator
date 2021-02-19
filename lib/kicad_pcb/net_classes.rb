require_relative 'net_class'
require_relative 'render'

#TODO: Don't forget about the interaction between net_classes and nets!!!!

class KicadPcb
  class NetClasses

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize
      #TODO: Add some way to initalize this with some values, optionally.
      #TODO: Decide if this should be an array or hash.
      #       - If net classes can't have duplicate names, then maybe it should be a hash indexed by names?
      #       - If they can have duplicate names, then an array is right.
      @net_classes = []
    end

    def add_net_class(net_class_hash)
      @net_classes << NetClass.new(net_class_hash)
    end

    def add_default_net_class
      default_values = {
        name: 'Default',
        description: 'This is the default net class.',
        clearance: '0.2',
        trace_width: '0.25',
        via_dia: '0.8',
        via_drill: '0.4',
        uvia_dia: '0.3',
        uvia_drill: '0.1'
      }
      add_net_class(default_values)
    end

    def to_sexpr
      output = ''
      @net_classes.each do |net_class|
        output << net_class.to_sexpr
        output << "\n"
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

