require 'forwardable'
require_relative 'net'
require_relative 'render'

#TODO: Don't forget about the interaction between net_classes and nets!!!!

class KicadPcb
  class Nets

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@nets, :[], :delete, :each, :include?, :key?, :length, :size

    def initialize
      @nets = {} #TODO: Or should it be an array??
    end

    def to_sexpr
    end

  end
end
