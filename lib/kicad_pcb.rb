require 'bigdecimal'
require 'bigdecimal/util'
require 'time'
require_relative 'kicad_pcb/pcb'
require_relative 'kicad_pcb/part'

module KicadPcb

  # Put shared constants and method here...

  # The meat of this method was taken from _indent method in this library:
  # https://github.com/samueldana/indentation
  # That library is copyright © 2010 Prometheus Computing
  # and uses the MIT License.
  # I'm no legal expert, but hopefully this meets the MIT license reqs.?
  # (If not, let me know and I'll update accordingly!)
  def self.indent(str, num = nil, i_char = ' ')
    str.to_s.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
  end

  # Convert from a kicad tstamp to a ruby time object
  # (kicad tstamp is seconds since unix epoch in hexadecimal)
  def self.tstamp_to_time(tstamp)
    Time.at(tstamp.to_i(16))
  end

  # Convert from a ruby time object to a kicad tstamp string
  # (kicad tstamp is seconds since unix epoch in hexadecimal)
  def self.current_tstamp
    Time.now.to_i.to_s(16).upcase
  end

  # Convert a number to a string that shows no more than so many decimal places (default: 4)
  # Works well for BigDecimals as well as normal Numerics.
  def self.num_to_s(num, places = 4)
    # Follows this structure: (bigdecimal.to_s("F") + "0000")[/.*\..{4}/]
    num.to_d.truncate(places).to_s("F")
  end

  # Convert a number to a string that shows exactly so many decimal places (default: 4)
  # Works well for BigDecimals as well as normal Numerics.
  def self.num_to_s_fixed_places(num, places = 4)
    # Follows this structure: (bigdecimal.to_s("F") + "0000")[/.*\..{4}/]
    (num.to_d.to_s("F") + ("0" * places))[/.*\..{#{places}}/]
  end

end

