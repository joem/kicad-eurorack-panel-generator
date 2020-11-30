require 'bigdecimal'
require 'bigdecimal/util'
require 'optparse'
require_relative './lib/kicad_pcb.rb'
require_relative './lib/eurorack.rb'

# This generates a eurorack panel sized correctly for the specified HP and
# optional formal (3U / Intellijel 1U / Pulp Logic 1U -- default is 3U).
# The panel includes mounting holes.
#
# Possible formats:
#   3u or 3U   = standard eurorack 3U
#   1ui or 1UI = Intellijel 1U
#   1up or 1UP = Pulp Logic 1U
#
# Possible hole sizes:
#   m3 or M3   = standard M3 holes
#
# Mounting hole position options (default is `auto`):
#   left  = mounting holes only on left
#   right = mounting holes only on right
#   both  = both right and left mounting holes
#   auto  = panels 9hp and skinnier only get mounting holes on left, panels 10hp and wider get left and right mounting holes 
#   none  = no mounting holes

# Parse all the options before doing anything else.
# -------------------------------------------------

# Set default options here if desired
@options = {
  format: '3U',
  hole_size: 'm3',
  mounting_hole_position: 'auto',
  hole_shape: 'round',
}

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options]"

  opts.separator "Options:"

  opts.on("-w", "--width HP", "The width of panel in HP") do |w|
    @options[:width_hp] = w
  end

  opts.on("-f", "--format FORMAT", "The format (default: 3U)") do |f|
    @options[:format] = f
  end

  #TODO: Maybe rename this --mounting-holes??
  opts.on("-p", "--position POSITION", "Mounting hole postion (default: auto)") do |mounting_hole_position|
    @options[:mounting_hole_position] = mounting_hole_position
  end

  #TODO: Uncomment this when you have a way to do oval holes
  # opts.on("--hole-shape SHAPE", "Shape of the holes (default: round)") do |hole_shape|
  #   @options[:hole_shape] = hole_shape
  # end

  #TODO: Uncomment this when you have a way to do other sizes (namely M2.5)
  # opts.on("--holes-size HOLESIZE", "The mounting hole size (default is M3)") do |hole_size|
  #   @options[:hole_size] = hole_size
  # end

  opts.on("-a", "--auto-extension", "Add .kicad_pcb to output filename") do |a|
    @options[:auto_extension] = a
  end

  opts.on("-o", "--output OUTPUTFILE", "The file to output", "(If not specified, output to stdout)") do |o|
    @options[:output_file] = o
  end

  # No argument, shows at tail.  This will print an options summary.
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

  ## Another typical switch to print the version.
  #opts.on_tail("--version", "Show version") do
  #  puts OptionParser::Version.join('.')
  #  exit
  #end

end.parse!

if (@options[:output_file] && @options[:auto_extension])
  # quick and easy way:
  @options[:output_file] = "#{@options[:output_file]}.kicad_pcb"
  # # probably too complex for its own good way:
  # two_parts = File.split(@options[:output_file])
  # two_parts[1] = "#{two_parts[1]}.kicad_pcb"
  # @options[:output_file] = File.join(two_parts)
end

if File.exists?(@options[:output_file].to_s)
  abort "Aborting. Output file already exists."
end

unless @options[:width_hp]
  abort "Aborting. You must specify a width."
end

unless ['3u', '1ui', '1up'].include? @options[:format].downcase
  abort "Aborting. Invalid format specified."
end

unless ['m3'].include? @options[:hole_size].downcase
  abort "Aborting. Invalid hole size specified."
end

unless ['auto', 'left', 'right', 'both', 'none'].include? @options[:mounting_hole_position].downcase
  abort "Aborting. Invalid hole type specified."
end

# Generate the PCB object
# -------------------------------------------------

@the_pcb = KicadPcb::Pcb.new

if @options[:width_hp]
  @the_pcb.board_width = Eurorack.panel_hp_to_mm(@options[:width_hp]).to_d.to_s('F')
end

case @options[:format]
when '3u', '3U'
  @the_pcb.board_height = Eurorack::EURORACK_3U_PANEL_MAX_HEIGHT.to_d.to_s('F')
when '1ui', '1UI'
  @the_pcb.board_height = Eurorack::EURORACK_1U_INTELLIJEL_PANEL_MAX_HEIGHT.to_d.to_s('F')
when '1up', '1UP'
  @the_pcb.board_height = Eurorack::EURORACK_1U_PULP_LOGIC_PANEL_MAX_HEIGHT.to_d.to_s('F')
end

#TODO: Add the mounting holes!!!!

DEFAULT_M3_HOLE_FOOTPRINT = "MountingHole:MountingHole_3.2mm_M3_DIN965"

def add_left_holes
  if @options[:width_hp].to_i == 1
    #TODO: Put holes somewhere good for 1hp??
  else
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, "7.5".to_d, 3.to_d)
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, "7.5".to_d, @the_pcb.board_height.to_d - 3.to_d)
  end
end

def add_right_holes
  if @options[:width_hp].to_i == 1
    #TODO: Put holes somewhere good for 1hp??
  else
    right_hole_x_pos = "7.5".to_d + ((@options[:width_hp].to_i - 3).to_d * "5.08".to_d)
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, right_hole_x_pos, 3.to_d)
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, right_hole_x_pos, @the_pcb.board_height.to_d - 3.to_d)
  end
end

case @options[:mounting_hole_position]
when 'auto'
  add_left_holes
  if @options[:width_hp].to_i >= 10
    add_right_holes
  end
when 'left'
  add_left_holes
when 'right'
  add_right_holes
when 'both'
  add_left_holes
  add_right_holes
when 'none'
end

# Output the PCB
# -------------------------------------------------

if @options[:output_file]
  puts "Writing #{@options[:output_file]}"
  File.open(@options[:output_file], 'w+') do |f|
    f.puts @the_pcb.to_s
  end
else
  puts @the_pcb.to_s
end



