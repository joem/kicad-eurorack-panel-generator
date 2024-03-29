require 'bigdecimal'
require 'bigdecimal/util'
require 'optparse'
require_relative '../lib/kicad_pcb.rb'
require_relative '../lib/eurorack.rb'

# This generates a eurorack panel sized correctly for the specified HP and
# optional formal (3U / Intellijel 1U / Pulp Logic 1U -- default is 3U).
# The panel includes mounting holes.
#
# Possible formats (case insensitive):
#   3u or 3U                 = standard eurorack 3U
#   1ui or 1UI or Intellijel = Intellijel 1U
#   1up or 1UP or Pulplogic  = Pulp Logic 1U
#
# Possible hole sizes (case insensitive):
#   m3 or M3   = standard M3 holes
#
# Mounting hole position options (default is `auto`) (case insensitive):
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
  mounting_hole_shape: 'round',
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

   opts.on("--hole-shape SHAPE", "Shape of the holes (default: round)") do |mounting_hole_shape|
     @options[:mounting_hole_shape] = mounting_hole_shape
   end

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

#TODO: Allow more formats of specifying the HP, like 4hp or hp4 instead of just an integer
#      - will need to abort if improper format is used
#      - will need to convert whatever format into integer

@options[:format] = Eurorack.valid_format(@options[:format])
unless @options[:format]
  abort "Aborting. Invalid format specified."
end

#TODO: Move these hole_size checks to KicadPcb or KicadPcb::Pcb or KicadPcb::Part?
#      - It's a pcb-specific thing, right??
#      - That way you can probably set a default part that way there?
# Ensure valid :hole_size input
unless ['m3'].include? @options[:hole_size].downcase
  abort "Aborting. Invalid hole size specified."
end

# Set the :hole_size to the correct strings we'll be using
@options[:hole_size] = @options[:hole_size].downcase

# Ensure valid :mounting_hole_position input
unless ['auto', 'left', 'right', 'both', 'none'].include? @options[:mounting_hole_position].downcase
  abort "Aborting. Invalid hole type specified."
end

# Set the :mounting_hole_position to the correct strings we'll be using
@options[:mounting_hole_position] = @options[:mounting_hole_position].downcase

# Ensure valid :mounting_hole_shape input
unless ['oval', 'round'].include? @options[:mounting_hole_shape].downcase
  abort "Aborting. Invalid hole shape specified."
end

# Set the :mounting_hole_shape to the correct strings we'll be using
@options[:mounting_hole_shape] = @options[:mounting_hole_shape].downcase

# Generate the PCB object
# -------------------------------------------------

@the_pcb = KicadPcb::Pcb.new

@the_pcb.board_width = Eurorack.panel_hp_to_mm(@options[:width_hp]).to_d.to_s('F')

@the_pcb.board_height = Eurorack::MAX_PANEL_HEIGHT[@options[:format]].to_d.to_s('F')

DEFAULT_M3_HOLE_FOOTPRINT = "MountingHole:MountingHole_3.2mm_M3_DIN965"

#TODO: See if these mounting hole rules also apply to Intellijel and Pulp Logic 1U!!!
#(Intellijel at least should)

def add_left_holes
  if @options[:width_hp].to_i == 1
    #TODO: Put holes somewhere good for 1hp??
    abort "Aborting. Mounting holes for 1hp not supported yet."
  else
    ref = '"Mounting Hole"'
    shape = @options[:mounting_hole_shape]
    left_hole_x_pos = Eurorack::LEFT_MOUNTING_HOLE_OFFESET
    left_hole_y1_pos = 3.to_d
    left_hole_y2_pos = @the_pcb.board_height.to_d - 3.to_d
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, left_hole_x_pos, left_hole_y1_pos, ref, nil, {hole_shape: shape})
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, left_hole_x_pos, left_hole_y2_pos, ref, nil, {hole_shape: shape})
  end
end

def add_right_holes
  if @options[:width_hp].to_i == 1
    #TODO: Put holes somewhere good for 1hp??
    abort "Aborting. Mounting holes for 1hp not supported yet."
  else
    ref = '"Mounting Hole"'
    shape = @options[:mounting_hole_shape]
    right_hole_x_pos = Eurorack::LEFT_MOUNTING_HOLE_OFFESET + ((@options[:width_hp].to_i - 3).to_d * Eurorack::HP_IN_MM)
    right_hole_y1_pos = 3.to_d
    right_hole_y2_pos = @the_pcb.board_height.to_d - 3.to_d
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, right_hole_x_pos, right_hole_y1_pos, ref, nil, {hole_shape: shape})
    @the_pcb.add_part(DEFAULT_M3_HOLE_FOOTPRINT, right_hole_x_pos, right_hole_y2_pos, ref, nil, {hole_shape: shape})
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
  puts "Generating new panel:"
  puts "  Format:         #{@options[:format]}"
  puts "  Width:          #{@options[:width_hp]} HP"
  puts "  Mounting holes:"
  puts "        Position: #{@options[:mounting_hole_position]}"
  puts "        Shape:    #{@options[:mounting_hole_shape]}"
  print "Writing #{@options[:output_file]} ... "
  File.open(@options[:output_file], 'w+') do |f|
    f.puts @the_pcb.to_s
  end
  puts "Done!"
else
  puts @the_pcb.to_s
end



