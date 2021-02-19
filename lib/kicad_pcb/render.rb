require 'bigdecimal'
require 'bigdecimal/util'

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
    if the_value.is_a?(BigDecimal)
      the_value.to_s("F")
    elsif the_value.is_a?(Float)
      the_value.to_s
    elsif the_value.is_a?(Integer)
      the_value.to_s
    elsif the_value.is_a?(String)
      if the_value == ''
        '""'
      elsif check_if_already_quoted(the_value)
        the_value
      elsif check_for_characters_that_need_quoting(the_value)
        "\"#{the_value}\""
      elsif check_for_dash_anywhere_but_first(the_value)
        "\"#{the_value}\""
      else
        the_value
      end
    else
      the_value # Not sure what else it might be, but I guess just use the_value?? Maybe it should raise an error?
    end
  end

  def check_for_characters_that_need_quoting(the_string)
    characters_that_need_quoting = [' ', "\t", '(', ')', '%', '{', '}']
    characters_that_need_quoting.any? { |s| the_string.include? s }
  end

  def check_for_dash_anywhere_but_first(the_string)
    # remove first character
    the_string = the_string[1..-1]
    # check for dashes
    the_string.include? '-'
  end

  # See if it starts and ends with quotes already
  # If it does, see if there are any other quotes
  #   If so, raise error
  #   If not, return true
  # If it doesn't, return false
  def check_if_already_quoted(the_string)
    if ((the_string[0] == '"') && (the_string[-1] == '"'))
      if the_string[1..-2].include?('"')
        raise "String passed to #{__callee__} has too many quotes"
      else
        true
      end
    else
      false
    end
  end

end

