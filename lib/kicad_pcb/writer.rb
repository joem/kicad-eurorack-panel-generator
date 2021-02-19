class KicadPcb
  class Writer

    # * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    #TODO: Rework this, since all classes have a #to_sexpr method that renders things.
    #       - all this needs to do is call #to_sexpr on the pcb and then write it to a file???
    # * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    # Refer to section 4 in this document to see the file spec: https://kicad.org/help/legacy_file_format_documentation.pdf

    def initialize(kicad_pcb_object)
      @kicad_pcb_object = kicad_pcb_object
    end

    def write
      the_output = ""

      the_output << write_open_list # initial open parentheses
      the_output << write_header
      the_output << "\n"

      the_middle = ""
      the_middle << write_general
      the_middle << "\n\n"
      the_middle << write_page
      the_middle << "\n\n"
      the_middle << write_layers
      the_middle << "\n\n"
      the_middle << write_setup
      the_middle << "\n\n"
      the_middle << write_nets
      the_middle << "\n\n"
      the_middle << write_net_classes
      the_middle << "\n"
      the_middle << write_modules
      the_middle << "\n"
      the_middle << write_graphic_items
      the_middle << "\n"
      the_middle << write_tracks
      the_middle << "\n"
      the_middle << write_zones

      the_output << indent(the_middle, 2)
      the_output << "\n"
      the_output << write_close_list # final closed parentheses

      return the_output
    end

    def to_s
      write
    end


    private


    def write_open_list
      '('
    end

    def write_header
      @kicad_pcb_object.header
    end

    def write_general
      # multi_line_list(keyword: 'general', data: @kicad_pcb_object.general)
      general_output = ''
      general_output << write_open_list
      general_output << "general\n"
      @kicad_pcb_object.general.to_h.each do |key, value|
        if [Hash, OpenStruct].any? { |c| value.is_a? c }
          general_output << indent(multi_line_list(keyword: key, data: value), 2)
          general_output << "\n"
        else
          general_output << single_line_list(keyword: key, data: format(value), newline: true, indent_amount: 2)
        end
      end
      general_output << single_line_list(keyword: 'drawings', data: format(@kicad_pcb_object.graphic_items.count), newline: true, indent_amount: 2)
      general_output << single_line_list(keyword: 'tracks', data: format(@kicad_pcb_object.tracks.count), newline: true, indent_amount: 2)
      general_output << single_line_list(keyword: 'zones', data: format(@kicad_pcb_object.zones.count), newline: true, indent_amount: 2)
      general_output << single_line_list(keyword: 'modules', data: format(@kicad_pcb_object.modules.count), newline: true, indent_amount: 2)
      general_output << single_line_list(keyword: 'nets', data: format(@kicad_pcb_object.nets.count), newline: true, indent_amount: 2)
      general_output << write_close_list
      return general_output
    end

    def write_page
      single_line_list(keyword: 'page', data: @kicad_pcb_object.page)
    end

    def write_layers
      multi_line_list(keyword: 'layers', data: @kicad_pcb_object.layers)
    end

    def write_setup
      multi_line_list(keyword: 'setup', data: @kicad_pcb_object.setup)
    end

    def write_nets
      nets_output = ''
      @kicad_pcb_object.nets.each_with_index do |net_name, index|
        nets_output << single_line_list(keyword: 'net', data: [index, net_name], newline: true)
      end
      return nets_output
    end

    def write_net_classes
      net_classes_output = ''
      @kicad_pcb_object.net_classes.each do |name, net_class|
        the_net_class = Marshal.load(Marshal.dump(net_class)) # do a deep copy so we can modify it later without touching original
        nets = the_net_class.nets
        net_classes_output << write_open_list
        net_classes_output << "net_class #{format(name)} #{format(the_net_class.description)}\n"
        # remove nets and description fron the_net_class
        the_net_class.delete_field(:description)
        the_net_class.delete_field(:nets)
        # iterate over what's left
        the_net_class.to_h.each do |key, value|
          net_classes_output << single_line_list(keyword: key, data: format(value), newline: true, indent_amount: 2)
        end
        nets.each do |net_name|
          net_classes_output << single_line_list(keyword: 'add_net', data: format(net_name), newline: true, indent_amount: 2)
        end
        net_classes_output << write_close_list
        net_classes_output << "\n"
      end
      return net_classes_output
    end

    def write_modules
      modules_output = ''
      # modules_output << "(<module>)\n" #DEBUG
      unless @kicad_pcb_object.modules.empty?
        #TODO: Implement me!!!
      end
      return modules_output
    end

    def write_graphic_items
      graphic_items_output = ''
      # graphic_items_output << "(<graphic item>)\n" #DEBUG
      unless @kicad_pcb_object.graphic_items.empty?
        #TODO: Implement me!!!
      end
      return graphic_items_output
    end

    def write_tracks
      tracks_output = ''
      # tracks_output << "(<track>)\n" #DEBUG
      unless @kicad_pcb_object.tracks.empty?
        #TODO: Implement me!!!
      end
      return tracks_output
    end

    def write_zones
      zones_output = ''
      # zones_output << "(<zone>)\n" #DEBUG
      unless @kicad_pcb_object.zones.empty?
        #TODO: Implement me!!!
      end
      return zones_output
    end

    def write_close_list
      ')'
    end

    def multi_line_list(keyword:, data:)
      if data.is_a?(Array)
        raise "Array not currently supported as data in method #{__callee__}"
      elsif data.is_a?(OpenStruct)
        return multi_line_list(keyword: keyword, data: data.to_h)
      elsif data.is_a?(Hash)
        multi_line_list_output = ''
        multi_line_list_output << write_open_list
        multi_line_list_output << "#{keyword}\n"
        # write each item in data with indent
        data.each do |key, value|
          if [Hash, OpenStruct].any? { |c| value.is_a? c }
            # If value is a hash or openstruct, do a nested multi-line list
            # (treating openstruct exactly the same in this case because the first openstruct check
            # in this method converts it to hash)
            multi_line_list_output << indent(multi_line_list(keyword: key, data: value), 2)
            multi_line_list_output << "\n"
          else
            # assume string or string-like (or array to be flattened)
            multi_line_list_output << single_line_list(keyword: key, data: format(value), newline: true, indent_amount: 2)
          end
        end
        # close list
        multi_line_list_output << write_close_list
        return multi_line_list_output
      else
        raise "String not currently supported as data in method #{__callee__}"
      end
    end

    # Note: This method formats the data for you, so you don't need to format it beforehand.
    # (That said, double-formatting it won't break anything.)
    def single_line_list(keyword:, data:, newline: false, indent_amount: 0)
      if newline
        optional_newline = "\n"
      else
        optional_newline = ""
      end
      if data.is_a?(Array)
        # If data is an array, the array is joined by spaces and put after keyword.
        "#{indent("(#{keyword} #{data.map{|value| format(value)}.join(' ')})", indent_amount)}#{optional_newline}"
      elsif data.is_a?(Hash)
        # If data is a hash, each hash element will be turned into "(key value)" and put after the keyword.
        #TODO: Make this flatten the hash in a good way and output on one line
        raise "Hash not currently supported as data in method #{__callee__}"
      else
        # assume string or string-like
        "#{indent("(#{keyword} #{format(data)})", indent_amount)}#{optional_newline}"
      end
    end

    ########################################################
    #NOTE: The below methods have all been moved to Render.
    ########################################################
    #     (if you need them here, you should include Render)
    ########################################################

    ## The meat of this method was taken from _indent method in this library:
    ## https://github.com/samueldana/indentation
    ## That library is copyright © 2010 Prometheus Computing
    ## and uses the MIT License.
    ## I'm no legal expert, but hopefully this meets the MIT license reqs.?
    ## (If not, let me know and I'll update accordingly!)
    #def indent(str, num = nil, i_char = ' ')
    #  str.to_s.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
    #end

    ## Formats values according to type, according to kicad_pcb file specs.
    ##
    ## It will not double-format a string, so don't worry about over-formatting.
    ##
    #def format(value)
    #  if value.is_a?(BigDecimal)
    #    value.to_s("F")
    #  elsif value.is_a?(Float)
    #    value.to_s
    #  elsif value.is_a?(Integer)
    #    value.to_s
    #  elsif value.is_a?(String)
    #    if value == ''
    #      '""'
    #    elsif check_if_already_quoted(value)
    #      value
    #    elsif check_for_characters_that_need_quoting(value)
    #      "\"#{value}\""
    #    elsif check_for_dash_anywhere_but_first(value)
    #      "\"#{value}\""
    #    else
    #      value
    #    end
    #  else
    #    value # Not sure what else it might be, but I guess just use value?? Maybe it should raise an error?
    #  end
    #end

    #def check_for_characters_that_need_quoting(the_string)
    #  characters_that_need_quoting = [' ', "\t", '(', ')', '%', '{', '}']
    #  characters_that_need_quoting.any? { |s| the_string.include? s }
    #end

    #def check_for_dash_anywhere_but_first(the_string)
    #  # remove first character
    #  the_string = the_string[1..-1]
    #  # check for dashes
    #  the_string.include? '-'
    #end

    ## See if it starts and ends with quotes already
    ## If it does, see if there are any other quotes
    ##   If so, raise error
    ##   If not, return true
    ## If it doesn't, return false
    #def check_if_already_quoted(the_string)
    #  if ((the_string[0] == '"') && (the_string[-1] == '"'))
    #    if the_string[1..-2].include?('"')
    #      raise "String passed to #{__callee__} has too many quotes"
    #    else
    #      true
    #    end
    #  else
    #    false
    #  end
    #end

  end
end

