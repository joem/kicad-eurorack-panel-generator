require 'forwardable'
require_relative 'layer'
require_relative 'render'

class KicadPcb
  class Layers

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@layers, :[], :delete, :each, :include?, :key?, :length, :size

    def initialize(layers_hash = nil)
      # Set up a hash
      @layers = {}
      # If we were passed a hash, use it to set some layers
      if layers_hash
        layers_hash.each do |number, layer_hash|
          set_layer(layer_hash)
        end
      end
      #TODO: Make @layers be a hash indexed by layer name instead of number? Since layer names are the only reference used elsewhere, it'd make it easy to check for layer names?
    end

    # Set a layer specified by layer_hash.
    # layer_hash must have the following keys: :number, :name, :type
    def set_layer(layer_hash)
      @layers[layer_hash[:number].to_s] = Layer.new(layer_hash)
    end

    def set_default_layers
      set_layer({number: '0', name: 'F.Cu', type: 'signal'})
      set_layer({number: '31', name: 'B.Cu', type: 'signal'})
      set_layer({number: '32', name: 'B.Adhes', type: 'user'})
      set_layer({number: '33', name: 'F.Adhes', type: 'user'})
      set_layer({number: '34', name: 'B.Paste', type: 'user'})
      set_layer({number: '35', name: 'F.Paste', type: 'user'})
      set_layer({number: '36', name: 'B.SilkS', type: 'user'})
      set_layer({number: '37', name: 'F.SilkS', type: 'user'})
      set_layer({number: '38', name: 'B.Mask', type: 'user'})
      set_layer({number: '39', name: 'F.Mask', type: 'user'})
      set_layer({number: '40', name: 'Dwgs.User', type: 'user'})
      set_layer({number: '41', name: 'Cmts.User', type: 'user'})
      set_layer({number: '42', name: 'Eco1.User', type: 'user'})
      set_layer({number: '43', name: 'Eco2.User', type: 'user'})
      set_layer({number: '44', name: 'Edge.Cuts', type: 'user'})
      set_layer({number: '45', name: 'Margin', type: 'user'})
      set_layer({number: '46', name: 'B.CrtYd', type: 'user'})
      set_layer({number: '47', name: 'F.CrtYd', type: 'user'})
      set_layer({number: '48', name: 'B.Fab', type: 'user'})
      set_layer({number: '49', name: 'F.Fab', type: 'user'})
      self # Without this, it just returns the return from the last #set call, which is kind of weird.
    end

    def to_sexpr
      # output the opening (layers line
      # iterate over hash of layers and do a to_sexpr on each of those
      # output closing )
      output = ''
      output << '(layers'
      output << "\n"
      if self.length > 0
        @layers.each do |_key, value|
          output << "  #{value.to_sexpr}"
          output << "\n"
        end
      end
      output << ')'
      return output
    end

    def to_h
      # Just in case compatibility with an older version is needed:
      # Ruby 1.8.7+: Hash[@layers.map{|key,value| [key, value.to_h] } ]
      # Ruby 2.1+: @layers.map { |key, value| [key, value.to_h] }.to_h
      # Ruby 2.4+:
      @layers.transform_values {|value| value.to_h}
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

