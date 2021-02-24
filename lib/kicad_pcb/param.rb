require 'time'
require_relative 'render'

# This is a convenience class designed to be used for instance variables, so
# that in #to_sexpr you can just use string interpolation and it'll get
# formatted/rendered correctly, since string interpolation calls #to_s on the
# objects.
#
# Calling #render_value on a Param object will simply call the Param's #to_s
# method, which will #render_value it's param. (I'm pretty sure I'm doing it
# correctly so it's all safe!)
#
# Additionally, when in a KicadPcb class that's require'd this class, you can
# quickly create a new Param like so:
#   @some_variable = Param["some value"]

class KicadPcb
  class Param

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def self.[](param = nil)
      if param.is_a? Param
        #TODO: Make this return a new clone instead of the exact same one? Can I use Marshal for that?
        param
      else
        Param.new param
      end
    end

    # Convert from a ruby time or datetime object to a kicad tstamp string
    # (kicad tstamp is seconds since unix epoch in hexadecimal)
    def self.timestamp(time_or_datetime_object)
      if time_or_datetime_object.is_a? DateTime
        datetime_object = time_or_datetime_object
        Param.new datetime_object.to_time.to_i.to_s(16).upcase
      elsif time_or_datetime_object.is_a? Time
        time_object = time_or_datetime_object
        Param.new time_object.to_i.to_s(16).upcase
      end
    end

    def self.current_timestamp
      # Param.new Time.now.to_i.to_s(16).upcase
      self.timestamp(Time.now)
    end

    def self.current_tstamp
      self.current_timestamp
    end

    def initialize(param = nil)
      @param = param
    end

    def raw
      @param
    end

    def set(param)
      @param = param
    end

    def render
      render_value @param
    end

    def to_s
      render
    end

  end
end
