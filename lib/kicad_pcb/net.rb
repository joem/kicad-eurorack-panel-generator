require 'forwardable'
require_relative 'render'
require_relative 'param'

class KicadPcb
  class Net

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    #TODO: Make this be attr_accessor instead?? And then make the net_hash in #initialize default to {}?
    attr_reader :number, :name

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :to_h, :[], :each, :include?, :key?, :length, :size

    def initialize(net_hash)
      @number = Param[net_hash[:number]]
      @name = Param[net_hash[:name]]
    end

    def to_sexpr
      "(net #{@number} #{@name})"
    end

    def to_h
      {
        number: @number.to_s,
        name: @name.to_s,
      }
    end

  end
end

# Each net has a net number and a name if in the schematic the net has a label.
#
# (net 0 "")
# (net 1 /SIGNAL)
# (net 2 GND)

