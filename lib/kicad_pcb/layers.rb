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
          @layers[number.to_s] = Layer.new({number: layer_hash[:number], name: layer_hash[:name], type: layer_hash[:type]})
        end
      end
      #TODO: Make @layers be a hash indexed by layer name instead of number? Since layer names are the only reference used elsewhere, it'd make it easy to check for layer names?
    end

    #TODO: Make this take a hash as input??
    def set(number, name, type)
      @layers[number.to_s] = Layer.new({number: number, name: name, type: type})
    end

    def set_default_layers
      set('0', 'F.Cu', 'signal')
      set('31', 'B.Cu', 'signal')
      set('32', 'B.Adhes', 'user')
      set('33', 'F.Adhes', 'user')
      set('34', 'B.Paste', 'user')
      set('35', 'F.Paste', 'user')
      set('36', 'B.SilkS', 'user')
      set('37', 'F.SilkS', 'user')
      set('38', 'B.Mask', 'user')
      set('39', 'F.Mask', 'user')
      set('40', 'Dwgs.User', 'user')
      set('41', 'Cmts.User', 'user')
      set('42', 'Eco1.User', 'user')
      set('43', 'Eco2.User', 'user')
      set('44', 'Edge.Cuts', 'user')
      set('45', 'Margin', 'user')
      set('46', 'B.CrtYd', 'user')
      set('47', 'F.CrtYd', 'user')
      set('48', 'B.Fab', 'user')
      set('49', 'F.Fab', 'user')
      self # Without this, it just returns the return from the last #set call, which is kind of weird.
    end

    def to_sexpr
      # output the opening (layers line
      # iterate over hash of layers and do a to_sexpr on each of those
      # output closing )
      #TODO: Make this use the methods from Render? Would require reworking how @layers is, I think?
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

