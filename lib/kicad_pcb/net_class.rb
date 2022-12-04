require_relative 'render'
require_relative 'param'

class KicadPcb
  class NetClass

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    attr_reader :name, :nets
    attr_accessor :description, :clearance, :trace_width, :via_dia, :via_drill, :uvia_dia, :uvia_drill

    def initialize(net_class_hash = {})
      # @name = net_class_hash[:name]
      @name = Param[net_class_hash[:name]]
      # @description = net_class_hash[:description]
      @description = Param[net_class_hash[:description]]
      @clearance = Param[net_class_hash[:clearance]]
      @trace_width = Param[net_class_hash[:trace_width]]
      @via_dia = Param[net_class_hash[:via_dia]]
      @via_drill = Param[net_class_hash[:via_drill]]
      @uvia_dia = Param[net_class_hash[:uvia_dia]]
      @uvia_drill = Param[net_class_hash[:uvia_drill]]
      #TODO: Ensure this is passed an array somehow?
      @nets = net_class_hash[:nets] || []
    end

    def set_from_array(net_class_array)
      # [:net_class, :Default, "This is the default net class.", [:clearance, :"0.2"], [:trace_width, :"0.25"], [:via_dia, :"0.8"], [:via_drill, :"0.4"], [:uvia_dia, :"0.3"], [:uvia_drill, :"0.1"], [:add_net, :"/Class123"], [:add_net, :GND], [:add_net, "Net-(C1-Pad2)"], [:add_net, "Net-(C2-Pad1)"], [:add_net, "Net-(C3-Pad1)"], [:add_net, "Net-(C3-Pad2)"], [:add_net, "Net-(C4-Pad1)"], [:add_net, "Net-(C6-Pad2)"], [:add_net, "Net-(J1-PadT)"], [:add_net, "Net-(J1-PadTN)"], [:add_net, "Net-(J2-PadT)"], [:add_net, "Net-(J2-PadTN)"], [:add_net, "Net-(R7-Pad1)"]]
      unless net_class_array[0] == :net_class
        raise StandardError.new "Invalid argument sent to #{self.class.name}#set_from_array: #{net_class_array.inspect}"
      end
      @name = Param[net_class_array[1]]
      @description = Param[net_class_array[2]]

      net_class_array.drop(3).each do |contents|
        if contents.kind_of?(Array)
          case contents[0]
          when :thickness
            @kicad_pcb.general.set_thickness contents[1]
          when :drawings
            @saved_drawings_count = Param[contents[1]]
          when :tracks
            @saved_tracks_count = Param[contents[1]]
          when :zones
            @saved_zones_count = Param[contents[1]]
          when :modules
            @saved_modules_count = Param[contents[1]]
          when :nets
            @saved_nets_count = Param[contents[1]]
          else
            raise StandardError.new "Invalid list item sent to #{self.class.name}#set_from_array: #{contents.inspect}"
          end
        else
          raise StandardError.new "Invalid list item sent to #{self.class.name}#set_from_array: #{contents.inspect}"
        end
      end


      net_class_array.drop(3).each do |contents|
        if contents.kind_of?(Array)
          if contents.size == 2
            if contents[0] == :add_net
              net_class_hash[:nets] ||= []
              net_class_hash[:nets] << contents[1]
            else
              net_class_hash[contents[0]] = contents[1]
            end
          elsif contents.size == 3
            net_class_hash[contents[0]] = [contents[1], contents[2]]
          else
            raise StandardError.new "Net Class parser saw wrong number of elements: #{contents.inspect}"
          end
        else
          raise StandardError.new "Net Class parser saw element it did not expect: #{contents.inspect}"
        end
      end

    end

    def set_from_hash(net_class_hash)
      @name = Param[net_class_hash[:name]]
      @description = Param[net_class_hash[:description]]
      @clearance = Param[net_class_hash[:clearance]]
      @trace_width = Param[net_class_hash[:trace_width]]
      @via_dia = Param[net_class_hash[:via_dia]]
      @via_drill = Param[net_class_hash[:via_drill]]
      @uvia_dia = Param[net_class_hash[:uvia_dia]]
      @uvia_drill = Param[net_class_hash[:uvia_drill]]
      #TODO: Ensure this is passed an array somehow?
      @nets = net_class_hash[:nets] || []
    end

    def add_net(net_name)
      # Only add it if it's not already there.
      unless net_name.to_s.empty?
        unless @nets.map(&:to_s).include?(net_name.to_s)
          @nets << Param[net_name]
        end
      end
    end

    #TODO: Make a delete_net(net_name) method

    # Return a string of the s-expression
    def to_sexpr
      output = ''
      # output << "(net_class #{render_array([@name, @description])}"
      output << "(net_class #{@name} #{@description}"
      output << "\n"
      output << "  (clearance #{@clearance})"
      output << "\n"
      output << "  (trace_width #{@trace_width})"
      output << "\n"
      output << "  (via_dia #{@via_dia})"
      output << "\n"
      output << "  (via_drill #{@via_drill})"
      output << "\n"
      output << "  (uvia_dia #{@uvia_dia})"
      output << "\n"
      output << "  (uvia_drill #{@uvia_drill})"
      output << "\n"
      @nets.each do |net_name|
        output << "  (add_net #{net_name})"
        output << "\n"
      end
      output << ')'
    end

    def to_h
      {
        name: @name.to_s,
        description: @description.to_s,
        clearance: @clearance.to_s,
        trace_width: @trace_width.to_s,
        via_dia: @via_dia.to_s,
        via_drill: @via_drill.to_s,
        uvia_dia: @uvia_dia.to_s,
        uvia_drill: @uvia_drill.to_s,
        nets: @nets.to_a.map { |item| item.to_s }
      }
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

#  (net_class Default "This is the default net class."
#    (clearance 0.2)
#    (trace_width 0.25)
#    (via_dia 0.8)
#    (via_drill 0.4)
#    (uvia_dia 0.3)
#    (uvia_drill 0.1)
#    (add_net +5V)
#    (add_net -12V)
#    (add_net -5V)
#    (add_net /front_A)
#    (add_net /front_B)
#    (add_net /front_C)
#    (add_net /front_D)
#    (add_net /front_E)
#    (add_net /front_F)
#    (add_net /front_G)
#    (add_net /front_H)
#    (add_net GND)
#    (add_net "Net-(C5-Pad2)")
#    (add_net "Net-(D3-Pad1)")
#    (add_net "Net-(J1-PadT)")
#    (add_net "Net-(J1-PadTN)")
#    (add_net "Net-(J2-PadT)")
#    (add_net "Net-(J2-PadTN)")
#    (add_net "Net-(J5-PadT)")
#    (add_net "Net-(J5-PadTN)")
#    (add_net "Net-(J6-PadT)")
#    (add_net "Net-(J6-PadTN)")
#    (add_net "Net-(J8-PadT)")
#    (add_net "Net-(J8-PadTN)")
#    (add_net "Net-(R13-Pad2)")
#    (add_net "Net-(R19-Pad2)")
#    (add_net "Net-(R3-Pad2)")
#    (add_net "Net-(U5-Pad7)")
#  )

