require 'forwardable'
require_relative 'render'
require_relative 'param'

class KicadPcb
  class Layer

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    #TODO: Make this be attr_accessor instead??
    attr_reader :number, :name, :type

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :to_h, :[], :each, :include?, :key?, :length, :size

    def initialize(layer_hash)
      @number = Param[layer_hash[:number]]
      @name = Param[layer_hash[:name]]
      @type = Param[layer_hash[:type]]
    end

    def to_sexpr
      "(#{@number} #{@name} #{@type})"
    end

    def to_h
      {
        number: @number.to_s,
        name: @name.to_s,
        type: @type.to_s
      }
      # The #to_s's above aren't really necessary, but they make the hash more manageable for external uses, I guess?
    end

  end
end

# (layers
#   (0 F.Cu signal)
#   (31 B.Cu signal)
#   (32 B.Adhes user)
#   (33 F.Adhes user)
#   (34 B.Paste user)
#   (35 F.Paste user)
#   (36 B.SilkS user)
#   (37 F.SilkS user)
#   (38 B.Mask user)
#   (39 F.Mask user)
#   (40 Dwgs.User user)
#   (41 Cmts.User user)
#   (42 Eco1.User user)
#   (43 Eco2.User user)
#   (44 Edge.Cuts user)
#   (45 Margin user)
#   (46 B.CrtYd user)
#   (47 F.CrtYd user)
#   (48 B.Fab user)
#   (49 F.Fab user)
# )

