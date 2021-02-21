require 'forwardable'
require_relative 'zone'
require_relative 'render'

class KicadPcb
  class Zones

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@zones, :[], :delete, :each, :include?, :key?, :length, :size

    def initialize
      @zones = {} #TODO: Or should it be an array?
    end

    def to_sexpr
    end

  end
end
