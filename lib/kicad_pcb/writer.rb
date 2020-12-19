class KicadPcb
  class Writer


    def initialize(kicad_pcb_object)
      @kicad_pcb_object = kicad_pcb_object
    end

    def write
      the_output = ""

      the_output << write_open_list # initial open parentheses
      the_output << write_header_line
      the_output << "\n"

      the_middle = ""
      the_middle << write_general_section
      the_middle << "\n\n"
      the_middle << write_page_section
      the_middle << "\n\n"
      the_middle << write_layers_section
      the_middle << "\n\n"
      the_middle << write_setup_section
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


    def write_open_list
      '('
    end

    def write_header_line
      @kicad_pcb_object.header_line
    end

    def write_general_section
      multi_line_list('general', @kicad_pcb_object.general_section)
    end

    def write_page_section
      single_line_list('page', @kicad_pcb_object.page_section)
    end

    def write_layers_section
      multi_line_list('layers', @kicad_pcb_object.layers_section)
    end

    def write_setup_section
      multi_line_list('setup', @kicad_pcb_object.setup_section)
    end

    def write_list_of_nets
      list_of_nets_output = ''
      list_of_nets = @kicad_pcb_object.list_of_nets
      list_of_nets.keys.sort.each do |key|
        list_of_nets_output << "#{single_line_list('net', [key, list_of_nets[key]])}\n"
      end
      return list_of_nets_output
    end

    def write_list_of_net_classes
      # put keyword, name, and description on top line
      # then put options one per line, indented
      '' #DEBUG #FIXME: Implement this stuff!
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
            multi_line_list_output << indent(single_line_list(key, value), 2)
            multi_line_list_output << "\n"
          end
        end
        # close list
        multi_line_list_output << write_close_list
        return multi_line_list_output
      else
        raise "String not currently supported as data in method #{__callee__}"
      end
    end

    def single_line_list(keyword, data)
      if data.is_a?(Array)
        # If data is an array, the array is joined by spaces and put after keyword.
        "(#{keyword} #{data.map{|value| format(value)}.join(' ')})"
      elsif data.is_a?(Hash)
        # If data is a hash, each hash element will be turned into "(key value)" and put after the keyword.
        #TODO: Make this flatten the hash in a good way and output on one line
        raise "Hash not currently supported as data in method #{__callee__}"
      else
        # assume string or string-like
        "(#{keyword} #{format(data)})"
      end
    end


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


    def format(value)
      # if a number, make it a nice string
      # if a string with spaces, quote it
      # otherwise just return the input
      # raise 'Implement format()!!!!!!'
      # value #DEBUG #FIXME
      if value.is_a?(BigDecimal)
        value.to_s("F")
      elsif value.is_a?(Float)
        value.to_s
      elsif value.is_a?(Integer)
        value.to_s
      elsif value.is_a?(String)
        if value == ''
          #TODO: Check to see if it's an empty string and then return an empty pair of quoted quotes
          '""'
        #elsif value.contains_bad_stuffffff
        #  #TODO: Check to see if it has anything that needs to be quoted and if so, quote it
        else
          value #DEBUG #FIXME
        end
      else
        value # leave it to chance!
      end
    end

  end
end

