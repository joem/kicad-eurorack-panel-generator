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
#
# Note: If the param is nil, that means it's not set. This will return an empty string when #to_s is called on it, but it should not always be treated the same as an empty string. As such there are a few method to help determine this: #nil?, #not_nil?, and present?. #nil? and #not_nil? are self-explanatory, but it #present? should be explained. In this case, #present? is the same thing as #not_nil?, which is slightly different behavior than Rails' #present? since that one returns false if the value checked is nil _or_ false. In our case false is a valid value, so only nil yields false for us.

class KicadPcb
  class Param

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def self.[](param = nil)
      if param.is_a? Param
        #TODO: Make this return a new clone instead of the exact same one? Can I use Marshal for that?
        param.dup
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

    def nil?
      @param == nil
    end

    def not_nil?
      !nil?
    end

    # NOTE : This is a little different from Rails' #present? method. This one
    # is only true if the param is not nil. If it's false, it's still present,
    # since that's a valid value to output.
    #
    def present?
      not_nil?
    end

    def set(param)
      @param = param
    end

    def render
      render_value @param
    end

    def to_a
      if @param.is_a? Array
        @param.to_a.map(&:to_s)
      else
        [render]
      end
    end

    def to_s
      render
    end

  end
end
