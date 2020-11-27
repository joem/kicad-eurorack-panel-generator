require 'bigdecimal'
require 'bigdecimal/util'
require 'time'

module KicadPcb

  # Per the KiCad file docs, an <item> is represented like:
  #   (<keyword> <parameter>)
  # So I will use item, keyword, and parameter in my terminology in this class.

  class Pcb

    GENERAL_SYMBOLS = [:setting_thickness, :setting_drawings, :setting_tracks, :setting_zones, :setting_modules, :setting_nets]
    GENERAL_SYMBOLS.each do |the_symbol|
      attr_accessor the_symbol
    end

    attr_accessor :setting_page

    SETUP_SYMBOLS = [:setting_last_trace_width, :setting_trace_clearance, :setting_zone_clearance, :setting_zone_45_only, :setting_trace_min, :setting_via_size, :setting_via_drill, :setting_via_min_size, :setting_via_min_drill, :setting_uvia_size, :setting_uvia_drill, :setting_uvias_allowed, :setting_uvia_min_size, :setting_uvia_min_drill, :setting_edge_width, :setting_segment_width, :setting_pcb_text_width, :setting_pcb_text_size, :setting_mod_edge_width, :setting_mod_text_size, :setting_mod_text_width, :setting_pad_size, :setting_pad_drill, :setting_pad_to_mask_clearance, :setting_solder_mask_min_width, :setting_aux_axis_origin, :setting_visible_elements]
    SETUP_SYMBOLS.each do |the_symbol|
      attr_accessor the_symbol
    end

    PCBPLOTPARAMS_SYMBOLS = [:setting_layerselection, :setting_usegerberextensions, :setting_usegerberattributes, :setting_usegerberadvancedattributes, :setting_creategerberjobfile, :setting_excludeedgelayer, :setting_linewidth, :setting_plotframeref, :setting_viasonmask, :setting_mode, :setting_useauxorigin, :setting_hpglpennumber, :setting_hpglpenspeed, :setting_hpglpendiameter, :setting_psnegative, :setting_psa4output, :setting_plotreference, :setting_plotvalue, :setting_plotinvisibletext, :setting_padsonsilk, :setting_subtractmaskfromsilk, :setting_outputformat, :setting_mirror, :setting_drillshape, :setting_scaleselection, :setting_outputdirectory]
    PCBPLOTPARAMS_SYMBOLS.each do |the_symbol|
      attr_accessor the_symbol
    end

    attr_accessor :board_origin_x, :board_origin_y
    attr_accessor :board_width, :board_height

    OPENING = '(kicad_pcb (version 20171130) (host pcbnew "(5.1.2-1)-1")'

    LAYERS_LIST = [
      '(0 F.Cu signal)',
      '(31 B.Cu signal)',
      '(32 B.Adhes user)',
      '(33 F.Adhes user)',
      '(34 B.Paste user)',
      '(35 F.Paste user)',
      '(36 B.SilkS user)',
      '(37 F.SilkS user)',
      '(38 B.Mask user)',
      '(39 F.Mask user)',
      '(40 Dwgs.User user)',
      '(41 Cmts.User user)',
      '(42 Eco1.User user)',
      '(43 Eco2.User user)',
      '(44 Edge.Cuts user)',
      '(45 Margin user)',
      '(46 B.CrtYd user)',
      '(47 F.CrtYd user)',
      '(48 B.Fab user)',
      '(49 F.Fab user)'
    ]

    # Initialize an instance with default values or use override values if
    # specified in keyword parameters.
    # 
    # Examples:
    # To create a new instance using all the default values:
    #   KicadPcb::Pcb.new
    # To create a new instance overriding the `thickness` and the `uvia_size`:
    #   KicadPcb::Pcb.new(setting_thickness: "2.0", setting_uvia_size: "0.4")
    #
    # Note that initial uses keyword arguments, so if you're passing it an
    # options hash, you'll need to use the double-splat for the options to be
    # parse, like so:
    #   OPTIONS_HASH = {setting_thickness: "2.0", setting_uvia_size: "0.4"}
    #   KicadPcb::Pcb.new(**OPTIONS_HASH)
    #
    def initialize(
      setting_thickness: "1.6",
      setting_drawings: "4",
      setting_tracks: "0",
      setting_zones: "0",
      setting_modules: "0",
      setting_nets: "1",
      setting_page: "A4",
      setting_last_trace_width: "0.25",
      setting_trace_clearance: "0.2",
      setting_zone_clearance: "0.508",
      setting_zone_45_only: "no",
      setting_trace_min: "0.2",
      setting_via_size: "0.8",
      setting_via_drill: "0.4",
      setting_via_min_size: "0.4",
      setting_via_min_drill: "0.3",
      setting_uvia_size: "0.3",
      setting_uvia_drill: "0.1",
      setting_uvias_allowed: "no",
      setting_uvia_min_size: "0.2",
      setting_uvia_min_drill: "0.1",
      setting_edge_width: "0.05",
      setting_segment_width: "0.2",
      setting_pcb_text_width: "0.3",
      setting_pcb_text_size: "1.5 1.5",
      setting_mod_edge_width: "0.12",
      setting_mod_text_size: "1 1",
      setting_mod_text_width: "0.15",
      setting_pad_size: "1.524 1.524",
      setting_pad_drill: "0.762",
      setting_pad_to_mask_clearance: "0.051",
      setting_solder_mask_min_width: "0.25",
      setting_aux_axis_origin: "0 0",
      setting_visible_elements: "FFFFFF7F",
      setting_layerselection: "0x010fc_ffffffff",
      setting_usegerberextensions: "false",
      setting_usegerberattributes: "false",
      setting_usegerberadvancedattributes: "false",
      setting_creategerberjobfile: "false",
      setting_excludeedgelayer: "true",
      setting_linewidth: "0.100000",
      setting_plotframeref: "false",
      setting_viasonmask: "false",
      setting_mode: "1",
      setting_useauxorigin: "false",
      setting_hpglpennumber: "1",
      setting_hpglpenspeed: "20",
      setting_hpglpendiameter: "15.000000",
      setting_psnegative: "false",
      setting_psa4output: "false",
      setting_plotreference: "true",
      setting_plotvalue: "true",
      setting_plotinvisibletext: "false",
      setting_padsonsilk: "false",
      setting_subtractmaskfromsilk: "false",
      setting_outputformat: "1",
      setting_mirror: "false",
      setting_drillshape: "1",
      setting_scaleselection: "1",
      setting_outputdirectory: '""',
      board_origin_x: "25", # just a little inside the A4 page
      board_origin_y: "25", # just a little inside the A4 page
      board_height: "100", # best deal per size at low volumes
      board_width: "100" # best deal per size at low volumes
    )
      @setting_thickness = setting_thickness
      @setting_drawings = setting_drawings
      @setting_tracks = setting_tracks
      @setting_zones = setting_zones
      @setting_modules = setting_modules
      @setting_nets = setting_nets
      @setting_page = setting_page
      @setting_last_trace_width = setting_last_trace_width
      @setting_trace_clearance = setting_trace_clearance
      @setting_zone_clearance = setting_zone_clearance
      @setting_zone_45_only = setting_zone_45_only
      @setting_trace_min = setting_trace_min
      @setting_via_size = setting_via_size
      @setting_via_drill = setting_via_drill
      @setting_via_min_size = setting_via_min_size
      @setting_via_min_drill = setting_via_min_drill
      @setting_uvia_size = setting_uvia_size
      @setting_uvia_drill = setting_uvia_drill
      @setting_uvias_allowed = setting_uvias_allowed
      @setting_uvia_min_size = setting_uvia_min_size
      @setting_uvia_min_drill = setting_uvia_min_drill
      @setting_edge_width = setting_edge_width
      @setting_segment_width = setting_segment_width
      @setting_pcb_text_width = setting_pcb_text_width
      @setting_pcb_text_size = setting_pcb_text_size
      @setting_mod_edge_width = setting_mod_edge_width
      @setting_mod_text_size = setting_mod_text_size
      @setting_mod_text_width = setting_mod_text_width
      @setting_pad_size = setting_pad_size
      @setting_pad_drill = setting_pad_drill
      @setting_pad_to_mask_clearance = setting_pad_to_mask_clearance
      @setting_solder_mask_min_width = setting_solder_mask_min_width
      @setting_aux_axis_origin = setting_aux_axis_origin
      @setting_visible_elements = setting_visible_elements
      @setting_layerselection = setting_layerselection
      @setting_usegerberextensions = setting_usegerberextensions
      @setting_usegerberattributes = setting_usegerberattributes
      @setting_usegerberadvancedattributes = setting_usegerberadvancedattributes
      @setting_creategerberjobfile = setting_creategerberjobfile
      @setting_excludeedgelayer = setting_excludeedgelayer
      @setting_linewidth = setting_linewidth
      @setting_plotframeref = setting_plotframeref
      @setting_viasonmask = setting_viasonmask
      @setting_mode = setting_mode
      @setting_useauxorigin = setting_useauxorigin
      @setting_hpglpennumber = setting_hpglpennumber
      @setting_hpglpenspeed = setting_hpglpenspeed
      @setting_hpglpendiameter = setting_hpglpendiameter
      @setting_psnegative = setting_psnegative
      @setting_psa4output = setting_psa4output
      @setting_plotreference = setting_plotreference
      @setting_plotvalue = setting_plotvalue
      @setting_plotinvisibletext = setting_plotinvisibletext
      @setting_padsonsilk = setting_padsonsilk
      @setting_subtractmaskfromsilk = setting_subtractmaskfromsilk
      @setting_outputformat = setting_outputformat
      @setting_mirror = setting_mirror
      @setting_drillshape = setting_drillshape
      @setting_scaleselection = setting_scaleselection
      @setting_outputdirectory = setting_outputdirectory

      @board_origin_x = board_origin_x
      @board_origin_y = board_origin_y
      @board_height = board_height
      @board_width = board_width
    end

    def accessor_to_item(accessor_symbol)
      "(#{accessor_symbol.to_s.sub(/^setting_/, '')} #{instance_variable_get("@#{accessor_symbol.to_s}")})"
    end

    def generate_list_of_items_from_accessors(array_of_symbols)
      array_of_symbols.map do |the_symbol|
        accessor_to_item(the_symbol)
      end
    end

    def general
      item_list = generate_list_of_items_from_accessors(GENERAL_SYMBOLS).join("\n")
      return <<~EOF_GENERAL.chomp
      (general
      #{indent(item_list, 2)}
      )
      EOF_GENERAL
    end

    def page
      accessor_to_item(:setting_page)
    end

    def layers
      item_list = LAYERS_LIST.join("\n")
      return <<~EOF_LAYERS.chomp
      (layers
      #{indent(item_list, 2)}
      )
      EOF_LAYERS
    end

    def setup
      item_list = generate_list_of_items_from_accessors(SETUP_SYMBOLS).join("\n")
      return <<~EOF_SETUP.chomp
      (setup
      #{indent(item_list, 2)}
      #{indent(pcbplotparams,2)}
      )
      EOF_SETUP
    end

    def pcbplotparams
      # The closing parentheses is on the same line as the last item here since
      # that's the way kicad does it. It doesn't matter though. <shrug>
      item_list = generate_list_of_items_from_accessors(PCBPLOTPARAMS_SYMBOLS).join("\n")
      return <<~EOF_PCBPLOTPARAMS.chomp
      (pcbplotparams
      #{indent(item_list, 2)})
      EOF_PCBPLOTPARAMS
    end

    def net
      '(net 0 "")'
    end

    def net_class
      return <<~EOF_NET_CLASS.chomp
      (net_class Default "This is the default net class."
        (clearance 0.2)
        (trace_width 0.25)
        (via_dia 0.8)
        (via_drill 0.4)
        (uvia_dia 0.3)
        (uvia_drill 0.1)
      )
      EOF_NET_CLASS
    end

    #TODO: Make these lines adjustable
    # def edge_cuts
    #   return <<~EOF_EDGE_CUTS.chomp
    #   (gr_line (start 13 28) (end 13 13) (layer Edge.Cuts) (width 0.05) (tstamp #{current_tstamp}))
    #   (gr_line (start 23 28) (end 13 28) (layer Edge.Cuts) (width 0.05))
    #   (gr_line (start 23 13) (end 23 28) (layer Edge.Cuts) (width 0.05))
    #   (gr_line (start 13 13) (end 23 13) (layer Edge.Cuts) (width 0.05))
    #   EOF_EDGE_CUTS
    # end
    def edge_cuts
      x1 = @board_origin_x.to_d
      y1 = @board_origin_y.to_d
      x2 = x1 + @board_width.to_d
      y2 = y1 + @board_height.to_d
      return <<~EOF_EDGE_CUTS.chomp
      (gr_line (start #{num_to_s(x1)} #{num_to_s(y1)}) (end #{num_to_s(x1)} #{num_to_s(y2)}) (layer Edge.Cuts) (width 0.05) (tstamp #{current_tstamp}))
      (gr_line (start #{num_to_s(x2)} #{num_to_s(y1)}) (end #{num_to_s(x1)} #{num_to_s(y1)}) (layer Edge.Cuts) (width 0.05))
      (gr_line (start #{num_to_s(x2)} #{num_to_s(y2)}) (end #{num_to_s(x2)} #{num_to_s(y1)}) (layer Edge.Cuts) (width 0.05))
      (gr_line (start #{num_to_s(x1)} #{num_to_s(y2)}) (end #{num_to_s(x2)} #{num_to_s(y2)}) (layer Edge.Cuts) (width 0.05))
      EOF_EDGE_CUTS
    end



    def output
      return <<~EOF_OUTPUT.chomp
      #{OPENING}

      #{indent(general,2)}

      #{indent(page,2)}
      #{indent(layers,2)}

      #{indent(setup,2)}

      #{indent(net,2)}

      #{indent(net_class,2)}

      #{indent(edge_cuts,2)}

      )
      EOF_OUTPUT
    end

    def to_s
      output
    end

    private

    # The meat of this method was taken from _indent method in this library:
    # https://github.com/samueldana/indentation
    # That library is copyright © 2010 Prometheus Computing
    # and uses the MIT License.
    # I'm no legal expert, but hopefully this meets the MIT license reqs.?
    # (If not, let me know and I'll update accordingly!)
    def indent(str, num = nil, i_char = ' ')
      str.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
    end

    # Convert from a kicad tstamp to a ruby time object
    # (kicad tstamp is seconds since unix epoch in hexadecimal)
    def tstamp_to_time(tstamp)
      Time.at(tstamp.to_i(16))
    end

    # Convert from a ruby time object to a kicad tstamp string
    # (kicad tstamp is seconds since unix epoch in hexadecimal)
    def current_tstamp
      Time.now.to_i.to_s(16).upcase
    end

    # Convert a number to a string that shows no more than so many decimal places (default: 4)
    # Works well for BigDecimals as well as normal Numerics.
    def num_to_s(num, places = 4)
      # Follows this structure: (bigdecimal.to_s("F") + "0000")[/.*\..{4}/]
      num.to_d.truncate(places).to_s("F")
    end

    # Convert a number to a string that shows exactly so many decimal places (default: 4)
    # Works well for BigDecimals as well as normal Numerics.
    def num_to_s_fixed_places(num, places = 4)
      # Follows this structure: (bigdecimal.to_s("F") + "0000")[/.*\..{4}/]
      (num.to_d.to_s("F") + ("0" * places))[/.*\..{#{places}}/]
    end

  end

end

