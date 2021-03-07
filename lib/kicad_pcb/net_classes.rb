require 'forwardable'
require_relative 'net_class'
require_relative 'render'

#TODO: Don't forget about the interaction between net_classes and nets!!!!

class KicadPcb
  class NetClasses

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    attr_reader :net_classes

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@net_classes, :[], :delete, :each, :include?, :key?, :length, :size


    def initialize(net_classes_hash = nil)
      # Set up a hash
      @net_classes = {}
      # If we were passed a hash, use it to set some net classes
      if net_classes_hash
        net_classes_hash.each do |_name, net_class_hash|
          add_net_class(net_class_hash)
        end
      end
    end

    def add_net_class(net_class_hash)
      @net_classes[net_class_hash[:name].to_s] = NetClass.new(net_class_hash)
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
      output_array = []
      # @net_classes.keys.sort.each do |key|
      @net_classes.keys.each do |key|
        output_array << @net_classes[key].to_sexpr
      end
      return output_array.join("\n")
    end

    def to_h
      @net_classes.transform_values {|value| value.to_h}
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

