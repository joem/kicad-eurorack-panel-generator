require 'bigdecimal'
require 'bigdecimal/util'
require_relative 'render'

class KicadPcb
  class Setup

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize(options_hash = {})
      @setup = options_hash
    end

    def set_default_setup
      @setup[:last_trace_width] = '0.25'.to_d
      @setup[:trace_clearance] = '0.2'.to_d
      @setup[:zone_clearance] = '0.508'.to_d
      @setup[:zone_45_only] = 'no'
      @setup[:trace_min] = '0.2'.to_d
      @setup[:via_size] = '0.8'.to_d
      @setup[:via_drill] = '0.4'.to_d
      @setup[:via_min_size] = '0.4'.to_d
      @setup[:via_min_drill] = '0.3'.to_d
      @setup[:uvia_size] = '0.3'.to_d
      @setup[:uvia_drill] = '0.1'.to_d
      @setup[:uvias_allowed] = 'no'
      @setup[:uvia_min_size] = '0.2'.to_d
      @setup[:uvia_min_drill] = '0.1'.to_d
      @setup[:edge_width] = '0.05'.to_d
      @setup[:segment_width] = '0.2'.to_d
      @setup[:pcb_text_width] = '0.3'.to_d
      @setup[:pcb_text_size] = ['1.5'.to_d, '1.5'.to_d]     # pair #TODO: How to enforce that it's a pair??
      @setup[:mod_edge_width] = '0.12'.to_d
      @setup[:mod_text_size] = ['1'.to_d, '1'.to_d]         # pair #TODO: How to enforce that it's a pair??
      @setup[:mod_text_width] = '0.15'.to_d
      @setup[:pad_size] = ['1.524'.to_d, '1.524'.to_d]      # pair #TODO: How to enforce that it's a pair??
      @setup[:pad_drill] = '0.762'.to_d
      @setup[:pad_to_mask_clearance] = '0.051'.to_d
      @setup[:solder_mask_min_width] = '0.25'.to_d
      @setup[:aux_axis_origin] = ['0'.to_d, '0'.to_d]       # pair #TODO: How to enforce that it's a pair??
      @setup[:visible_elements] = 'FFFFFF7F'
      @setup[:pcbplotparams] = {}
      @setup[:pcbplotparams][:layerselection] = '0x010fc_ffffffff'
      @setup[:pcbplotparams][:usegerberextensions] = false
      @setup[:pcbplotparams][:usegerberattributes] = false
      @setup[:pcbplotparams][:usegerberadvancedattributes] = false
      @setup[:pcbplotparams][:creategerberjobfile] = false
      @setup[:pcbplotparams][:excludeedgelayer] = true
      @setup[:pcbplotparams][:linewidth] = '0.150000'.to_d
      @setup[:pcbplotparams][:plotframeref] = false
      @setup[:pcbplotparams][:viasonmask] = false
      @setup[:pcbplotparams][:mode] = 1
      @setup[:pcbplotparams][:useauxorigin] = false
      @setup[:pcbplotparams][:hpglpennumber] = 1
      @setup[:pcbplotparams][:hpglpenspeed] = '20' #TODO: What to do about this? Int or BigDec?
      @setup[:pcbplotparams][:hpglpendiameter] = '15.000000'.to_d
      @setup[:pcbplotparams][:psnegative] = false
      @setup[:pcbplotparams][:psa4output] = false
      @setup[:pcbplotparams][:plotreference] = true
      @setup[:pcbplotparams][:plotvalue] = true
      @setup[:pcbplotparams][:plotinvisibletext] = false
      @setup[:pcbplotparams][:padsonsilk] = false
      @setup[:pcbplotparams][:subtractmaskfromsilk] = false
      @setup[:pcbplotparams][:outputformat] = 1
      @setup[:pcbplotparams][:mirror] = false
      @setup[:pcbplotparams][:drillshape] = 1
      @setup[:pcbplotparams][:scaleselection] = '1' #TODO: What to do about this? Int or BigDec?
      @setup[:pcbplotparams][:outputdirectory] = ''
    end

    def [](key)
      @layers[key.to_s]
    end

    def length
      @layers.length
    end

    alias size length

    def to_sexpr
      # output the opening (setup line
      # iterate over hash (without pcbplotparams) and output them
      # output the opening (pcbplotparams line
      # iterate over pcbplotparams and output them
      # output closing )
      # output closing )
      # OLD METHOD:
      # # pcbplotparams = Marshal.load(Marshal.dump(@setup[:pcbplotparams]))
      # # output = ''
      # # output << '(setup'
      # # output << "\n"
      # # #TODO: This definitely feels like a method can be extracted here and reused...
      # # if self.length > 0
      # #   @setup.each do |key, value|
      # #     next if key == :pcbplotparams
      # #     if value.is_a? Array
      # #       output << "  (#{key.to_s} #{value[0]} #{value[1]})"
      # #     else
      # #       output << "  (#{key.to_s} #{value})"
      # #     end
      # #     output << "\n"
      # #   end
      # #   output << '  (pcbplotparams'
      # #   output << "\n"
      # #   pcbplotparams.each do |key, value|
      # #     if value.is_a? Array
      # #       output << "  (#{key.to_s} #{value[0]} #{value[1]})"
      # #     else
      # #       output << "  (#{key.to_s} #{value})"
      # #     end
      # #     output << "\n"
      # #   end
      # #   output << '  )'
      # # end
      # # output << ')'
      # # return output
      output = ''
      output << '(setup'
      output << "\n"
      output << indent(render_hash(@setup), 2)
      output << "\n"
      output << ')'
      return output
    end

    #private

    ##TODO: Is there a way to share these private methods amongst all the classes that need them??
    ##       - Maybe make the classes inherit from a generic class?
    ##       - Or can I `include` them or something like that?

    ## The meat of this method was taken from _indent method in this library:
    ## https://github.com/samueldana/indentation
    ## That library is copyright © 2010 Prometheus Computing
    ## and uses the MIT License.
    ## I'm no legal expert, but hopefully this meets the MIT license reqs.?
    ## (If not, let me know and I'll update accordingly!)
    #def indent(str, num = nil, i_char = ' ')
    #  str.to_s.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
    #end

    ## Render an array as a string with a space between each array item.
    ## Handles different types of array items, rendering appropriately.
    #def render_array(the_array)
    #  string_array = []
    #  the_array.each do |item|
    #    string_array << render_value(item)
    #  end
    #  return string_array.join(" ")
    #end

    ## Render a single value as a string.
    ## Handles different types of values, rendering appropriately.
    #def render_value(the_value)
    #  if the_value.is_a? BigDecimal
    #    the_value.to_s("F")
    #  else
    #    the_value.to_s
    #  end
    #end

    #def render_hash(the_hash)
    #  output = ""
    #  the_hash.each do |key, value|
    #    if value.is_a? Array
    #      output << "(#{key.to_s} #{render_array(value)})"
    #    elsif value.is_a? Hash
    #      output << "(#{key.to_s}"
    #      output << "\n"
    #      output << indent(render_hash(value), 2)
    #      output << ')'
    #    else
    #      output << "(#{key.to_s} #{render_value(value)})"
    #    end
    #    output << "\n"
    #  end
    #  return output
    #end

  end
end



# @setup = OpenStruct.new(
#   last_trace_width: '0.25'.to_d,
#   trace_clearance: '0.2'.to_d,
#   zone_clearance: '0.508'.to_d,
#   zone_45_only: 'no',
#   trace_min: '0.2'.to_d,
#   via_size: '0.8'.to_d,
#   via_drill: '0.4'.to_d,
#   via_min_size: '0.4'.to_d,
#   via_min_drill: '0.3'.to_d,
#   uvia_size: '0.3'.to_d,
#   uvia_drill: '0.1'.to_d,
#   uvias_allowed: 'no',
#   uvia_min_size: '0.2'.to_d,
#   uvia_min_drill: '0.1'.to_d,
#   edge_width: '0.05'.to_d,
#   segment_width: '0.2'.to_d,
#   pcb_text_width: '0.3'.to_d,
#   pcb_text_size: ['1.5'.to_d, '1.5'.to_d],
#   mod_edge_width: '0.12'.to_d,
#   mod_text_size: ['1'.to_d, '1'.to_d],
#   mod_text_width: '0.15'.to_d,
#   pad_size: ['1.524'.to_d, '1.524'.to_d],
#   pad_drill: '0.762'.to_d,
#   pad_to_mask_clearance: '0.051'.to_d,
#   solder_mask_min_width: '0.25'.to_d,
#   aux_axis_origin: ['0'.to_d, '0'.to_d],
#   visible_elements: 'FFFFFF7F',
#   pcbplotparams: OpenStruct.new(
#     layerselection: '0x010fc_ffffffff',
#     usegerberextensions: false,
#     usegerberattributes: false,
#     usegerberadvancedattributes: false,
#     creategerberjobfile: false,
#     excludeedgelayer: true,
#     linewidth: '0.150000'.to_d,
#     plotframeref: false,
#     viasonmask: false,
#     mode: 1,
#     useauxorigin: false,
#     hpglpennumber: 1,
#     hpglpenspeed: '20', #TODO: What to do about this? Int or BigDec?
#     hpglpendiameter: '15.000000'.to_d,
#     psnegative: false,
#     psa4output: false,
#     plotreference: true,
#     plotvalue: true,
#     plotinvisibletext: false,
#     padsonsilk: false,
#     subtractmaskfromsilk: false,
#     outputformat: 1,
#     mirror: false,
#     drillshape: 1,
#     scaleselection: '1', #TODO: What to do about this? Int or BigDec?
#     outputdirectory: ''
#   )
# )

