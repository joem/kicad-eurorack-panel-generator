require 'forwardable'
require_relative 'net_class'
require_relative 'render'

#TODO: Don't forget about the interaction between net_classes and nets!!!!

class KicadPcb
  class NetClasses

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@net_classes, :[], :delete, :each, :include?, :key?, :length, :size


    def initialize
      #TODO: Add some way to initalize this with some values, optionally.
      @net_classes = {}
    end

    def add_net_class(net_class_hash)
      # @net_classes << NetClass.new(net_class_hash)
      @net_classes[net_class_hash[:name]] = NetClass.new(net_class_hash)
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
      @net_classes.each do |_key, net_class|
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

