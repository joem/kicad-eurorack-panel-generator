require 'optparse'
require_relative './lib/kicad_pcb.rb'

# This generates a eurorack panel sized correctly for the specified HP and
# optional formal (3U / Intellijel 1U / Pulp Logic 1U -- default is 3U).
# The panel includes mounting holes.
#


# Parse all the options before doing anything else.
# -------------------------------------------------

# Set default options here if desired
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options]"

  opts.separator "Options:"

  # opts.on("-x", "--x-size XSIZE", "The x-size of pcb (in mm)") do |x|
  #   options[:x_size] = x
  # end

  # opts.on("-y", "--y-size YSIZE", "The y-size of pcb (in mm)") do |y|
  #   options[:y_size] = y
  # end

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





a = KicadPcb::Pcb.new

puts a.output


