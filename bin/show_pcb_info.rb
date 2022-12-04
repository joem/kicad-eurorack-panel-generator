require 'bigdecimal'
require 'bigdecimal/util'
require 'optparse'
require_relative 'lib/sexpr_parser.rb'
# require_relative 'lib/eurorack.rb'
# require_relative 'lib/parsed_part.rb'

#TODO: Update this to just show interesting pcb info
#        - size of board
#        - anything else??
#TODO: Make it as minimal and modular as possible


# Old description:
# This program parses out all the Edge.Cuts features.
# It also figures out what a good size panel is, based on the size of the input pcb.

# Parse all the options before doing anything else.
# -------------------------------------------------

# Set default options here if desired
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options] INPUTFILE"

  opts.separator "Options:"

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

if ARGV.empty?
  abort "Needs input file"
end

# read command line argument as input file (simple not-great-but-ok-for-now way)
input = File.read(ARGV[0])

# do some parsing!:
parseddata = SexprParser.parse(input)

SKIPPABLE_TOKENS = [
  :version,
  :host,
  :general,
  :page,
  :layers,
  :setup,
  :net,
  :net_class,
  :module,
]

def find_board_outline(s_expr)
  result_array = []
  s_expr[0].each do |contents|
    if contents.kind_of?(Array)
      next if SKIPPABLE_TOKENS.include?(contents[0].to_s)     # This SKIPPABLE_TOKENS stuff might speed it up on big files?
      if contents.include?([:layer, :"Edge.Cuts"])
        result_array << contents
      end
    end
  end
  return result_array
end

board_outline_array = find_board_outline(parseddata)

@x_vals = []
@y_vals = []

board_outline_array.each do |line|
  line.drop(1).each do |element|
    if element.kind_of?(Array)
      case element[0]
      when :start
        @x_vals << element[1].to_s.to_d
        @y_vals << element[2].to_s.to_d
      when :end
        @x_vals << element[1].to_s.to_d
        @y_vals << element[2].to_s.to_d
      end
    end
  end
end

@x_min = @x_vals.min
@x_max = @x_vals.max
@y_min = @y_vals.min
@y_max = @y_vals.max

@x_length = @x_max - @x_min
@y_length = @y_max - @y_min

# if [@x_length, @y_length].min > Eurorack::MAX_PCB_HEIGHT['3U']
#   abort "Board won't fit in eurorack space"
# end

def num_to_s(num, places = 4)
  num.to_d.truncate(places).to_s("F")
end

puts "X length: #{num_to_s(@x_length)} mm"
puts "Y length: #{num_to_s(@y_length)} mm"

# @hp = nil
# @x_dimensions = "x-coords"

# if @y_length < Eurorack::MAX_PCB_HEIGHT['3U']
#   # assume y will be the height, so see how many hp x takes up
#   @hp = Eurorack.minimum_hp(@x_length)
# else
#   # assume x will be the height, so see how many hp y takes up
#   @x_dimensions = "y-coords"
#   @hp = Eurorack.minimum_hp(@y_length)
# end

# puts "X dimensions:" #DEBUG
# puts "    #{@x_dimensions}" #DEBUG
# puts "HP:" #DEBUG
# puts "    #{@hp}" #DEBUG


#TODO: Put this all into a module or class!!!

#TODO: Might need to only look at start/end if it's a gr_line
#         - what else can end up on the edge cuts layer???
#         - what other drawing things are there??

#NOTE: To convert from BigDecimal to a string of an accurate float, use:
# the_big_decimal.to_s("F")
#NOTE: To convert from BigDecimal to a string of an accurate float with exactly 4 decimal places, use:
# (the_big_decimal.to_s("F") + "0000")[ /.*\..{4}/ ]


  # (gr_line (start 15 55) (end 15 15) (layer Edge.Cuts) (width 0.05) (tstamp 5FBB130F))
  # (gr_line (start 65 55) (end 15 55) (layer Edge.Cuts) (width 0.05))
  # (gr_line (start 65 15) (end 65 55) (layer Edge.Cuts) (width 0.05))
  # (gr_line (start 15 15) (end 65 15) (layer Edge.Cuts) (width 0.05))

