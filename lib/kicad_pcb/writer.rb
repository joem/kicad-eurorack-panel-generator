class KicadPcb
  class Writer

    # Refer to section 4 in this document to see the file spec: https://kicad.org/help/legacy_file_format_documentation.pdf

    def initialize(kicad_pcb_object)
      @kicad_pcb_object = kicad_pcb_object
    end

    def write
      the_output = ""

      the_output << write_open_list # initial open parentheses
      the_output << write_header_line
      the_output << "\n"

      the_middle = ""
      the_middle << write_general_settings
      the_middle << "\n\n"
      the_middle << write_page_settings
      the_middle << "\n\n"
      the_middle << write_layers_settings
      the_middle << "\n\n"
      the_middle << write_setup_settings
      the_middle << "\n\n"
      the_middle << write_list_of_nets
      the_middle << "\n\n"
      the_middle << write_list_of_net_classes
      the_middle << "\n\n"
      the_middle << write_list_of_modules
      the_middle << "\n\n"
      the_middle << write_list_of_graphic_items
      the_middle << "\n\n"
      the_middle << write_list_of_tracks
      the_middle << "\n\n"
      the_middle << write_list_of_zones

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

    def write_header_line
      @kicad_pcb_object.header_line
    end

    def write_general_settings
      multi_line_list('general', @kicad_pcb_object.general_settings)
    end

    def write_page_settings
      single_line_list('page', @kicad_pcb_object.page_settings)
    end

    def write_layers_settings
      multi_line_list('layers', @kicad_pcb_object.layers_settings)
    end

    def write_setup_settings
      multi_line_list('setup', @kicad_pcb_object.setup_settings)
    end

    def write_list_of_nets
      list_of_nets_output = ''
      list_of_nets = @kicad_pcb_object.list_of_nets
      list_of_nets.keys.sort.each do |key|
        list_of_nets_output << single_line_list('net', [key, list_of_nets[key]], true)
      end
      return list_of_nets_output
    end

    def write_list_of_net_classes
      list_of_net_classes_output = ''
      @kicad_pcb_object.list_of_net_classes.each do |net_class|
        list_of_net_classes_output << write_open_list
        list_of_net_classes_output << "net_class #{format(net_class['name'])} #{format(net_class['description'])}\n"
        net_class['options'].each do |key, value|
          list_of_net_classes_output << single_line_list(key, format(value), true, 2)
        end
        list_of_net_classes_output << write_close_list
      end
      return list_of_net_classes_output
    end

    def write_list_of_modules
      list_of_modules_output = ''
      unless @kicad_pcb_object.list_of_modules.empty?
        #TODO: Implement me!!!
      end
      return list_of_modules_output
    end

    def write_list_of_graphic_items
      list_of_graphic_items_output = ''
      unless @kicad_pcb_object.list_of_graphic_items.empty?
        #TODO: Implement me!!!
      end
      return list_of_graphic_items_output
    end

    def write_list_of_tracks
      list_of_tracks_output = ''
      unless @kicad_pcb_object.list_of_tracks.empty?
        #TODO: Implement me!!!
      end
      return list_of_tracks_output
    end

    def write_list_of_zones
      list_of_zones_output = ''
      unless @kicad_pcb_object.list_of_zones.empty?
        #TODO: Implement me!!!
      end
      return list_of_zones_output
    end

    def write_close_list
      ')'
    end

    def multi_line_list(keyword, data)
      if data.is_a?(Array)
        raise "Array not currently supported as data in method #{__callee__}"
      elsif data.is_a?(Hash)
        multi_line_list_output = ''
        multi_line_list_output << write_open_list
        multi_line_list_output << "#{keyword}\n"
        # write each item in data with indent
        data.each do |key, value|
          if value.is_a?(Hash)
            # If value is a hash, do a nested multi-line list
            multi_line_list_output << indent(multi_line_list(key, value), 2)
            multi_line_list_output << "\n"
          else
            # assume string or string-like (or array to be flattened)
            # multi_line_list_output << indent(single_line_list(key, value), 2)
            # multi_line_list_output << "\n"
            multi_line_list_output << single_line_list(key, format(value), true, 2)
          end
        end
        # close list
        multi_line_list_output << write_close_list
        return multi_line_list_output
      else
        raise "String not currently supported as data in method #{__callee__}"
      end
    end

    #TODO: Rework this to have keyword arguments so that calling it makes more sense!
    def single_line_list(keyword, data, newline=false, indent_amount=0)
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

    # The meat of this method was taken from _indent method in this library:
    # https://github.com/samueldana/indentation
    # That library is copyright © 2010 Prometheus Computing
    # and uses the MIT License.
    # I'm no legal expert, but hopefully this meets the MIT license reqs.?
    # (If not, let me know and I'll update accordingly!)
    def indent(str, num = nil, i_char = ' ')
      str.to_s.split("\n", -1).collect{|line| (i_char * num) + line}.join("\n")
    end

    def format(value)
      if value.is_a?(BigDecimal)
        value.to_s("F")
      elsif value.is_a?(Float)
        value.to_s
      elsif value.is_a?(Integer)
        value.to_s
      elsif value.is_a?(String)
        if value == ''
          '""'
        elsif check_for_characters_that_need_quoting(value)
          "\"#{value}\""
        elsif check_for_dash_anywhere_but_first(value)
          "\"#{value}\""
        else
          value
        end
      else
        value # Not sure what else it might be, but I guess just use value?? Maybe it should raise an error?
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


  end
end

