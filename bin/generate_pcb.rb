require 'optparse'
require_relative '../lib/kicad_pcb.rb'

# This generates a PCB of the specified size.
# If no size is specified, it makes it 100mm x 100mm.
#

# Parse all the options before doing anything else.
# -------------------------------------------------

# Set default options here if desired
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options]"

  opts.separator "Options:"

  opts.on("-x", "--x-size XSIZE", "The x-size of pcb (in mm)") do |x|
    options[:x_size] = x
  end

  opts.on("-y", "--y-size YSIZE", "The y-size of pcb (in mm)") do |y|
    options[:y_size] = y
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
  abort "Output file already exists."
end

# Do things
# -------------------------------------------------

the_pcb = KicadPcb::Pcb.new

if options[:x_size]
  the_pcb.board_width = options[:x_size]
end

if options[:y_size]
  the_pcb.board_height = options[:y_size]
end

if options[:output_file]
  puts "Writing #{options[:output_file]}"
  File.open(options[:output_file], 'w+') do |f|
    f.puts the_pcb.to_s
  end
else
  puts the_pcb.to_s
end


