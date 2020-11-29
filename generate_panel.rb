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

#TODO: Add the mounting holes!!!! (see near end of file)

# Parse all the options before doing anything else.
# -------------------------------------------------

# Set default options here if desired
options = {format: '3U'}

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options]"

  opts.separator "Options:"

  opts.on("-w", "--width HP", "The width of panel in HP") do |w|
    options[:width] = w
  end

  opts.on("-f", "--format FORMAT", "The format (default is 3U)", "(See docs for posible formats)") do |f|
    options[:format] = f
  end

  opts.on("-h", "--holes HOLESIZE", "The mounting hole size (default is M3)", "(See docs for posible formats)") do |h|
    options[:hole_size] = h
  end

  opts.on("-a", "--auto-extension", "Add .kicad_pcb to output filename") do |a|
    options[:auto_extension] = a
  end

  opts.on("-o", "--output OUTPUTFILE", "The file to output", "(If not specified, output to stdout)") do |o|
    options[:output_file] = o
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

if (options[:output_file] && options[:auto_extension])
  # quick and easy way:
  options[:output_file] = "#{options[:output_file]}.kicad_pcb"
  # # probably too complex for its own good way:
  # two_parts = File.split(options[:output_file])
  # two_parts[1] = "#{two_parts[1]}.kicad_pcb"
  # options[:output_file] = File.join(two_parts)
end

if File.exists?(options[:output_file].to_s)
  abort "Aborting. Output file already exists."
end

unless options[:width]
  abort "Aborting. You must specify a width."
end

unless ['3u', '1ui', '1up'].include? options[:format].downcase
  abort "Aborting. Invalid format specified."
end

unless ['m3'].include? options[:hole_size].downcase
  abort "Aborting. Invalid hole size specified."
end

# Do things
# -------------------------------------------------

@the_pcb = KicadPcb::Pcb.new

if options[:width]
  @the_pcb.board_width = Eurorack.panel_hp_to_mm(options[:width]).to_d.to_s('F')
end

case options[:format]
when '3u', '3U'
  @the_pcb.board_height = Eurorack::EURORACK_3U_PANEL_MAX_HEIGHT.to_d.to_s('F')
when '1ui', '1UI'
  @the_pcb.board_height = Eurorack::EURORACK_1U_INTELLIJEL_PANEL_MAX_HEIGHT.to_d.to_s('F')
when '1up', '1UP'
  @the_pcb.board_height = Eurorack::EURORACK_1U_PULP_LOGIC_PANEL_MAX_HEIGHT.to_d.to_s('F')
end

#TODO: Add the mounting holes!!!!

if options[:output_file]
  puts "Writing #{options[:output_file]}"
  File.open(options[:output_file], 'w+') do |f|
    f.puts @the_pcb.to_s
  end
else
  puts @the_pcb.to_s
end



