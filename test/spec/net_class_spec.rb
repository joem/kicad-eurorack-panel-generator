require 'test_helper'

#TODO: test that you can't add a net twice

#TODO: test that you can't change the name from outside

#TODO: test that you can't edit .nets directly from outside

#TODO: test that nets is empty if there are not nets set (esp. during to_sexpr)

#TODO: test that a default value is set for most of the settings if none is provided


#require_relative 'render'

#class KicadPcb
#  class NetClass

#    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

#    attr_reader :name, :nets
#    attr_accessor :description, :clearance, :trace_width, :via_dia, :via_drill, :uvia_dia, :uvia_drill

#    def initialize(net_class_hash = {})
#        @name = net_class_hash[:name]
#        @description = net_class_hash[:description]
#        @clearance = net_class_hash[:clearance]
#        @trace_width = net_class_hash[:trace_width]
#        @via_dia = net_class_hash[:via_dia]
#        @via_drill = net_class_hash[:via_drill]
#        @uvia_dia = net_class_hash[:uvia_dia]
#        @uvia_drill = net_class_hash[:uvia_drill]
#        #TODO: Ensure this is passed an array:
#        @nets = net_class_hash[:nets] || []
#    end

#    def add_net(net_name)
#      # Only add it if it's not already there.
#      unless @nets.include?(net_name)
#        @nets << net_name
#      end
#    end

#    def to_sexpr
#      output = ''
#      output << "(net_class #{render_array([@name, @description])}"
#      output << "\n"
#      output << "  (clearance #{render_value(@clearance)})"
#      output << "\n"
#      output << "  (trace_width #{render_value(@trace_width)})"
#      output << "\n"
#      output << "  (via_dia #{render_value(@via_dia)})"
#      output << "\n"
#      output << "  (via_drill #{render_value(@via_drill)})"
#      output << "\n"
#      output << "  (uvia_dia #{render_value(@uvia_dia)})"
#      output << "\n"
#      output << "  (uvia_drill #{render_value(@uvia_drill)})"
#      output << "\n"
#      @nets.each do |net_name|
#        output << "  (add_net #{render_value(net_name)})"
#        output << "\n"
#      end
#      output << ')'
#    end

#  end
#end


##  (net_class Default "This is the default net class."
##    (clearance 0.2)
##    (trace_width 0.25)
##    (via_dia 0.8)
##    (via_drill 0.4)
##    (uvia_dia 0.3)
##    (uvia_drill 0.1)
##  )
