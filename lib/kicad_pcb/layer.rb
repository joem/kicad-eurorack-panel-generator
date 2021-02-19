require_relative 'render'

class KicadPcb
  class Layer

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize(number, name, type)
      @number = number
      @name = name
      @type = type
    end

    def to_sexpr
      # "(#{render_value(@number)} #{render_value(@name)} #{render_value(@type)})"
      "(#{render_array([@number, @name, @type])})"
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

