require 'forwardable'
require_relative 'net'
require_relative 'render'

#TODO: Don't forget about the interaction between net_classes and nets!!!!
#       - maybe make methods in KicadPcb for #add_net and such, so it can access both classes?

class KicadPcb
  class Nets

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    attr_reader :nets

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@nets, :[], :delete, :each, :include?, :key?, :keys, :length, :size

    def initialize(nets_hash = nil)
      @nets = {} #TODO: Or should it be an array??
      if nets_hash
        nets_hash.each do |_number, net_hash|
          set_net(net_hash)
        end
      end
    end

    # Set a net specified by net_hash.
    # net_hash must have the following keys: :number, :name
    def set_net(net_hash)
      # Index by number since name can be blank
      @nets[net_hash[:number].to_i] = Net.new(net_hash)
      self # So it can be chained.
    end

    def set_default_net
      set_net({number: '0', name: '""'})
    end

    def add_net(name:)
      set_net({number: @nets.size.to_s, name: name})
      # This works with @nets.size because that's one higher than the index (since the index starts at 0).
    end

    def <<(name)
      add_net(name: name)
    end

    def to_sexpr
      # output = ''
      # @nets.each do |_key, net|
      #   output << net.to_sexpr
      #   output << "\n"
      # end
      # return output
      output_array = []
      @nets.keys.sort.each do |key|
        output_array << @nets[key].to_sexpr
      end
      return output_array.join("\n")
    end

    def to_h
      @nets.transform_values {|value| value.to_h}
    end

  end
end

# Each net has a net number and a name if in the schematic the net has a label.
#
# (net 0 "")
# (net 1 /SIGNAL)
# (net 2 GND)

