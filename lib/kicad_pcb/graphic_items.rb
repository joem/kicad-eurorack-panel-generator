require 'forwardable'
require_relative 'graphic_item'
require_relative 'render'

class KicadPcb
  class GraphicItems

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@graphic_items, :[], :delete, :each, :include?, :key?, :length, :size

    def initialize
      @graphic_items = {} #TODO: Or should it be an array?
    end

    def to_sexpr
    end

  end
end
