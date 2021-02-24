require 'bigdecimal'
require 'bigdecimal/util'
# require_relative 'param'

#NOTE: This module gets `include`'d in several other classes, so please don't
#change or remove the method names. (Or at least not without also updating
#everywhere that calls it.)

module Render

  private

  # The meat of this method was taken from _indent method in this library:
  # https://github.com/samueldana/indentation
  # That library is copyright © 2010 Prometheus Computing
  # and uses the MIT License.
  # I'm no legal expert, but hopefully this meets the MIT license reqs.?
  # (If not, let me know and I'll update accordingly!)
  def indent(str, num = nil, i_char = ' ')
    str.to_s.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
  end

  # Render an array as a string with a space between each array item.
  # Handles different types of array items, rendering appropriately.
  def render_array(the_array)
    string_array = []
    the_array.each do |item|
      string_array << render_value(item)
    end
    return string_array.join(" ")
  end

  def render_hash(the_hash)
    output = ""
    the_hash.each do |key, value|
      if value.is_a? Array
        output << "(#{key.to_s} #{render_array(value)})"
      elsif value.is_a? Hash
        output << "(#{key.to_s}"
        output << "\n"
        output << indent(render_hash(value), 2)
        output << ')'
      else
        output << "(#{key.to_s} #{render_value(value)})"
      end
      output << "\n"
    end
    return output
  end

  # Renders single values according to type, according to kicad_pcb file specs.
  #
  # It will not double-format a string, so don't worry about over-formatting.
  #
  def render_value(the_value)
    #TODO: How to handle if it's a Param correctly????????
    # if the_value.is_a?(KicadPcb::Param)
    #   the_value.to_s
    # elsif the_value.is_a?(BigDecimal)
    if the_value.is_a?(BigDecimal)
      the_value.to_s("F")
    elsif the_value.is_a?(Float)
      the_value.to_s
    elsif the_value.is_a?(Integer)
      the_value.to_s
    elsif the_value.is_a?(String)
      # Convert \n and \t to \\n and \\t -- and don't double-convert it
      the_value = the_value.gsub(/\n/, '\\n')
      the_value = the_value.gsub(/\t/, '\\t')
      if the_value == ''
        '""'
      elsif check_if_already_quoted(the_value)
        the_value
      elsif check_for_characters_that_need_quoting(the_value)
        #NOTE: This elsif needs to be done AFTER the `elsif check_if_already_quoted` one.
        # Double any embedded quotes and quote the whole thing
        "\"#{the_value.gsub(/"/,'""')}\""
      elsif check_for_dash_anywhere_but_first(the_value)
        "\"#{the_value}\""
      else
        the_value
      end
    else
      the_value
      # Not sure what else it might be, but I guess just use the_value??
      # Maybe it should raise an error? #FIXME
    end
  end

  def check_for_characters_that_need_quoting(the_string)
    characters_that_need_quoting = [' ', "\t", "\\t", "\n", "\\n", '(', ')', '%', '{', '}', '#']
    characters_that_need_quoting.any? { |s| the_string.include? s }
  end

  def check_for_dash_anywhere_but_first(the_string)
    # remove first character
    the_string = the_string[1..-1]
    # check for dashes
    the_string.include? '-'
  end

  # See if it starts and ends with quotes already
  def check_if_already_quoted(the_string)
    if ((the_string[0] == '"') && (the_string[-1] == '"'))
      true
    else
      false
    end
  end

  # See if there are any quotes other than leading or trailing
  def check_for_embedded_quote(the_string)
    if the_string[1..-2].include?('"')
      true
    else
      false
    end
  end

end

