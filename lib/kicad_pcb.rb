require 'bigdecimal'
require 'bigdecimal/util'
require 'ostruct'
require 'time'
require_relative 'kicad_pcb/parser'
require_relative 'kicad_pcb/writer'

# require_relative 'kicad_pcb/graphic_item' # required in graphic_items
require_relative 'kicad_pcb/graphic_items'
require_relative 'kicad_pcb/header'
# require_relative 'kicad_pcb/layer' # required in layers
require_relative 'kicad_pcb/layers'
# require_relative 'kicad_pcb/net_class' # required in net_classes
require_relative 'kicad_pcb/net_classes'
# require_relative 'kicad_pcb/net' # required in nets
require_relative 'kicad_pcb/nets'
require_relative 'kicad_pcb/page'
# require_relative 'kicad_pcb/part' # required in parts
require_relative 'kicad_pcb/parts'
require_relative 'kicad_pcb/setup'
# require_relative 'kicad_pcb/track' # required in tracks
require_relative 'kicad_pcb/tracks'
# require_relative 'kicad_pcb/zone' # required in zones
require_relative 'kicad_pcb/zones'


# Some notes about the KiCad PCB file format:
# - The coordinate system is a screen coordinate with (0,0) in the top left.
# - The units are always mm regardless of your grid unit settings.

class KicadPcb

  # attr_accessor :header
  # attr_accessor :general
  # attr_accessor :page
  # attr_accessor :layers
  # attr_accessor :setup
  # attr_accessor :nets
  # attr_accessor :net_classes
  # attr_accessor :modules
  # attr_accessor :graphic_items
  # attr_accessor :tracks
  # attr_accessor :zones

  # top level things:
  #
  #  (version)
  #  (host)
  #  (general)
  #  (page)
  #  (layers)
  #  (setup)
  #  (net)          or is it multiple (net)'s? check on a routed pcb! (also see how board with rats nest looks!)
  #  (net_class)    or is it multiple (net_class)'s? check on a routed pcb!
  #  multiple (module)'s
  #  multiple (gr_line)'s     or can they be other things? see how a board with a circle outline looks!
  #
  #

  # Return a new KicadPcb object once it parses
  def self.parse()
    #TODO: Make this work!
    # Parser.new()
  end


  #FIXME: These are the old module methods.... need to put them somewhere else for the most part!

  # # The meat of this method was taken from _indent method in this library:
  # # https://github.com/samueldana/indentation
  # # That library is copyright © 2010 Prometheus Computing
  # # and uses the MIT License.
  # # I'm no legal expert, but hopefully this meets the MIT license reqs.?
  # # (If not, let me know and I'll update accordingly!)
  # def self.indent(str, num = nil, i_char = ' ')
  #   str.to_s.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
  # end

  # # Convert from a kicad tstamp to a ruby time object
  # # (kicad tstamp is seconds since unix epoch in hexadecimal)
  # def self.tstamp_to_time(tstamp)
  #   Time.at(tstamp.to_i(16))
  # end

  # # Convert from a ruby time object to a kicad tstamp string
  # # (kicad tstamp is seconds since unix epoch in hexadecimal)
  # def self.current_tstamp
  #   Time.now.to_i.to_s(16).upcase
  # end

  # # Convert a number to a string that shows no more than so many decimal places (default: 4)
  # # Works well for BigDecimals as well as normal Numerics.
  # def self.num_to_s(num, places = 4)
  #   # Follows this structure: (bigdecimal.to_s("F") + "0000")[/.*\..{4}/]
  #   num.to_d.truncate(places).to_s("F")
  # end

  # # Convert a number to a string that shows exactly so many decimal places (default: 4)
  # # Works well for BigDecimals as well as normal Numerics.
  # def self.num_to_s_fixed_places(num, places = 4)
  #   # Follows this structure: (bigdecimal.to_s("F") + "0000")[/.*\..{4}/]
  #   (num.to_d.to_s("F") + ("0" * places))[/.*\..{#{places}}/]
  # end


  #TODO: What are some options that might need to be set upon doing KicadPcb.new?? Add them to the initializer arguments but with defaults.
  def initialize()

    @header = Header.new
    @header.set_defaults

    # @general = []           #=> some sort of structure defined in KicadPcb !!!!
    @page = Page.new

    @layers = Layers.new
    @layers.set_default_layers

    @setup = Setup.new
    @setup.set_default_setup

    @nets = Nets.new

    @net_classes = NetClasses.new
    @net_classes.add_default_net_class

    @parts = Parts.new

    @graphic_items = GraphicItems.new

    @tracks = Tracks.new

    @zones = Zones.new



    #TODO: Find out if I can or should change the host to mention my ruby program?
    @header = 'kicad_pcb (version 20171130) (host pcbnew "(5.1.2-1)-1")'
    @general = OpenStruct.new(
      thickness: '1.6'.to_d,
    )
    @page = 'A4' # The docs consider this a part of the General Section, even though it's a separate item!
    # We might not want to do this one right away, in case they're overridden or duplicated or something in a user pcb file?
    @layers = OpenStruct.new(
      '0' => ['F.Cu', 'signal'],
      '31' => ['B.Cu', 'signal'],
      '32' => ['B.Adhes', 'user'],
      '33' => ['F.Adhes', 'user'],
      '34' => ['B.Paste', 'user'],
      '35' => ['F.Paste', 'user'],
      '36' => ['B.SilkS', 'user'],
      '37' => ['F.SilkS', 'user'],
      '38' => ['B.Mask', 'user'],
      '39' => ['F.Mask', 'user'],
      '40' => ['Dwgs.User', 'user'],
      '41' => ['Cmts.User', 'user'],
      '42' => ['Eco1.User', 'user'],
      '43' => ['Eco2.User', 'user'],
      '44' => ['Edge.Cuts', 'user'],
      '45' => ['Margin', 'user'],
      '46' => ['B.CrtYd', 'user'],
      '47' => ['F.CrtYd', 'user'],
      '48' => ['B.Fab', 'user'],
      '49' => ['F.Fab', 'user']
    )
    @setup = OpenStruct.new(
      last_trace_width: '0.25'.to_d,
      trace_clearance: '0.2'.to_d,
      zone_clearance: '0.508'.to_d,
      zone_45_only: 'no',
      trace_min: '0.2'.to_d,
      via_size: '0.8'.to_d,
      via_drill: '0.4'.to_d,
      via_min_size: '0.4'.to_d,
      via_min_drill: '0.3'.to_d,
      uvia_size: '0.3'.to_d,
      uvia_drill: '0.1'.to_d,
      uvias_allowed: 'no',
      uvia_min_size: '0.2'.to_d,
      uvia_min_drill: '0.1'.to_d,
      edge_width: '0.05'.to_d,
      segment_width: '0.2'.to_d,
      pcb_text_width: '0.3'.to_d,
      pcb_text_size: ['1.5'.to_d, '1.5'.to_d],
      mod_edge_width: '0.12'.to_d,
      mod_text_size: ['1'.to_d, '1'.to_d],
      mod_text_width: '0.15'.to_d,
      pad_size: ['1.524'.to_d, '1.524'.to_d],
      pad_drill: '0.762'.to_d,
      pad_to_mask_clearance: '0.051'.to_d,
      solder_mask_min_width: '0.25'.to_d,
      aux_axis_origin: ['0'.to_d, '0'.to_d],
      visible_elements: 'FFFFFF7F',
      pcbplotparams: OpenStruct.new(
        layerselection: '0x010fc_ffffffff',
        usegerberextensions: false,
        usegerberattributes: false,
        usegerberadvancedattributes: false,
        creategerberjobfile: false,
        excludeedgelayer: true,
        linewidth: '0.150000'.to_d,
        plotframeref: false,
        viasonmask: false,
        mode: 1,
        useauxorigin: false,
        hpglpennumber: 1,
        hpglpenspeed: '20', #TODO: What to do about this? Int or BigDec?
        hpglpendiameter: '15.000000'.to_d,
        psnegative: false,
        psa4output: false,
        plotreference: true,
        plotvalue: true,
        plotinvisibletext: false,
        padsonsilk: false,
        subtractmaskfromsilk: false,
        outputformat: 1,
        mirror: false,
        drillshape: 1,
        scaleselection: '1', #TODO: What to do about this? Int or BigDec?
        outputdirectory: ''
      )
    )
    #TODO: Make this a list of hashes, not just a single hash!!! We need to be able to add to it! (Don't we?? Is a hash OK??)
    # @nets = {
    #   0 => ''
    # }
    # @net_classes = []
    @net_classes = {}
    add_net_class(name: 'Default', description: 'This is the default net class.')
    @nets = []
    add_net(net_name: '', net_class: nil) # net 0 with no name doesn't get added to any net class
    @modules = []
    @graphic_items = []
    @tracks = []
    @zones = []
  end

  def add_net_class(
        name:,
        description: '',
        clearance: '0.2',
        trace_width: '0.25',
        via_dia: '0.8',
        via_drill: '0.4',
        uvia_dia: '0.3',
        uvia_drill: '0.1',
        nets: []
  )
    @net_classes[name] = OpenStruct.new(
      description: description,
      clearance: clearance.to_d,
      trace_width: trace_width.to_d,
      via_dia: via_dia.to_d,
      via_drill: via_drill.to_d,
      uvia_dia: uvia_dia.to_d,
      uvia_drill: uvia_drill.to_d,
      nets: nets
    )
  end

  def add_net(net_name:, net_class: 'Default')
    @nets << net_name
    # add net to net_class:
    if net_class
      @net_classes[net_class].nets << net_name
    end
  end

  def add_module
    #TODO: Implement this!
  end

  def add_graphic_item
    #TODO: Implement this!
  end

  def add_track
    #TODO: Implement this!
  end

  def add_zone
    #TODO: Implement this!
  end

  def write()
    #TODO: or should this be render() or generate() or something else??
    # calls Writer.new
    @writer = Writer.new(self)
    return @writer.to_s
  end


  # Returns a KicadPcb object of the derived front panel
  def derive_front_panel()
    # calls KicadPcb.new
  end


end

require_relative "kicad_pcb/version" #FIXME: Why is this at the end????


# Below is a blank pcb. It was made by starting a blank KiCad project then opening and then saving the pcb.
# Use it as a reference for what to use as the base Pcb model.

#     (kicad_pcb (version 20171130) (host pcbnew "(5.1.2-1)-1")
#
#       (general
#         (thickness 1.6)
#         (drawings 0)
#         (tracks 0)
#         (zones 0)
#         (modules 0)
#         (nets 1)
#       )
#
#       (page A4)
#       (layers
#         (0 F.Cu signal)
#         (31 B.Cu signal)
#         (32 B.Adhes user)
#         (33 F.Adhes user)
#         (34 B.Paste user)
#         (35 F.Paste user)
#         (36 B.SilkS user)
#         (37 F.SilkS user)
#         (38 B.Mask user)
#         (39 F.Mask user)
#         (40 Dwgs.User user)
#         (41 Cmts.User user)
#         (42 Eco1.User user)
#         (43 Eco2.User user)
#         (44 Edge.Cuts user)
#         (45 Margin user)
#         (46 B.CrtYd user)
#         (47 F.CrtYd user)
#         (48 B.Fab user)
#         (49 F.Fab user)
#       )
#
#       (setup
#         (last_trace_width 0.25)
#         (trace_clearance 0.2)
#         (zone_clearance 0.508)
#         (zone_45_only no)
#         (trace_min 0.2)
#         (via_size 0.8)
#         (via_drill 0.4)
#         (via_min_size 0.4)
#         (via_min_drill 0.3)
#         (uvia_size 0.3)
#         (uvia_drill 0.1)
#         (uvias_allowed no)
#         (uvia_min_size 0.2)
#         (uvia_min_drill 0.1)
#         (edge_width 0.05)
#         (segment_width 0.2)
#         (pcb_text_width 0.3)
#         (pcb_text_size 1.5 1.5)
#         (mod_edge_width 0.12)
#         (mod_text_size 1 1)
#         (mod_text_width 0.15)
#         (pad_size 1.524 1.524)
#         (pad_drill 0.762)
#         (pad_to_mask_clearance 0.051)
#         (solder_mask_min_width 0.25)
#         (aux_axis_origin 0 0)
#         (visible_elements FFFFFF7F)
#         (pcbplotparams
#           (layerselection 0x010fc_ffffffff)
#           (usegerberextensions false)
#           (usegerberattributes false)
#           (usegerberadvancedattributes false)
#           (creategerberjobfile false)
#           (excludeedgelayer true)
#           (linewidth 0.150000)
#           (plotframeref false)
#           (viasonmask false)
#           (mode 1)
#           (useauxorigin false)
#           (hpglpennumber 1)
#           (hpglpenspeed 20)
#           (hpglpendiameter 15.000000)
#           (psnegative false)
#           (psa4output false)
#           (plotreference true)
#           (plotvalue true)
#           (plotinvisibletext false)
#           (padsonsilk false)
#           (subtractmaskfromsilk false)
#           (outputformat 1)
#           (mirror false)
#           (drillshape 1)
#           (scaleselection 1)
#           (outputdirectory ""))
#       )
#
#       (net 0 "")
#
#       (net_class Default "This is the default net class."
#         (clearance 0.2)
#         (trace_width 0.25)
#         (via_dia 0.8)
#         (via_drill 0.4)
#         (uvia_dia 0.3)
#         (uvia_drill 0.1)
#       )
#
#     )





# # If you make a new instance of KicadPcb, for example like so:
#
# pcb = KicadPcb.new
#
# # It will have all of the following accessors:
#
# pcb.header
# pcb.general
# pcb.general.thickness
# pcb.page
# pcb.layers
# pcb.layers.'0'    # This layers stuff needs work, may change, probably isn't even how it's listed here...
# pcb.layers.'31'
# pcb.layers.'32'
# pcb.layers.'33'
# pcb.layers.'34'
# pcb.layers.'35'
# pcb.layers.'36'
# pcb.layers.'37'
# pcb.layers.'38'
# pcb.layers.'39'
# pcb.layers.'40'
# pcb.layers.'41'
# pcb.layers.'42'
# pcb.layers.'43'
# pcb.layers.'44'
# pcb.layers.'45'
# pcb.layers.'46'
# pcb.layers.'47'
# pcb.layers.'48'
# pcb.layers.'49'
# pcb.setup
# pcb.setup.last_trace_width
# pcb.setup.trace_clearance
# pcb.setup.zone_clearance
# pcb.setup.zone_45_only
# pcb.setup.trace_min
# pcb.setup.via_size
# pcb.setup.via_drill
# pcb.setup.via_min_size
# pcb.setup.via_min_drill
# pcb.setup.uvia_size
# pcb.setup.uvia_drill
# pcb.setup.uvias_allowed
# pcb.setup.uvia_min_size
# pcb.setup.uvia_min_drill
# pcb.setup.edge_width
# pcb.setup.segment_width
# pcb.setup.pcb_text_width
# pcb.setup.pcb_text_size
# pcb.setup.mod_edge_width
# pcb.setup.mod_text_size
# pcb.setup.mod_text_width
# pcb.setup.pad_size
# pcb.setup.pad_drill
# pcb.setup.pad_to_mask_clearance
# pcb.setup.solder_mask_min_width
# pcb.setup.aux_axis_origin
# pcb.setup.visible_elements
# pcb.setup.pcbplotparams
# pcb.setup.pcbplotparams.layerselection
# pcb.setup.pcbplotparams.usegerberextensions
# pcb.setup.pcbplotparams.usegerberattributes
# pcb.setup.pcbplotparams.usegerberadvancedattributes
# pcb.setup.pcbplotparams.creategerberjobfile
# pcb.setup.pcbplotparams.excludeedgelayer
# pcb.setup.pcbplotparams.linewidth
# pcb.setup.pcbplotparams.plotframeref
# pcb.setup.pcbplotparams.viasonmask
# pcb.setup.pcbplotparams.mode
# pcb.setup.pcbplotparams.useauxorigin
# pcb.setup.pcbplotparams.hpglpennumber
# pcb.setup.pcbplotparams.hpglpenspeed
# pcb.setup.pcbplotparams.hpglpendiameter
# pcb.setup.pcbplotparams.psnegative
# pcb.setup.pcbplotparams.psa4output
# pcb.setup.pcbplotparams.plotreference
# pcb.setup.pcbplotparams.plotvalue
# pcb.setup.pcbplotparams.plotinvisibletext
# pcb.setup.pcbplotparams.padsonsilk
# pcb.setup.pcbplotparams.subtractmaskfromsilk
# pcb.setup.pcbplotparams.outputformat
# pcb.setup.pcbplotparams.mirror
# pcb.setup.pcbplotparams.drillshape
# pcb.setup.pcbplotparams.scaleselection
# pcb.setup.pcbplotparams.outputdirectory
# pcb.nets
# pcb.net_classes
# pcb.modules
# pcb.graphic_items
# pcb.tracks
# pcb.zones


# The following are NOT attributes, since they're derived directly from the instance variables:
#
# pcb.general.drawings   -> use pcb.graphic_items.count instead
# pcb.general.tracks     -> use pcb.tracks.count instead
# pcb.general.zones      -> use pcb.zones.count instead
# pcb.general.modules    -> use pcb.modules.count instead
# pcb.general.nets       -> use pcb.nets.count instead


