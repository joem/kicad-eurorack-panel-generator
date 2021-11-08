require_relative '../sexpr_parser.rb'
# require_relative '../kicad_pcb' # is this necessary? KicadPcb requires this file, so isn't this then circular??

class KicadPcb
  class Parser

    attr_reader :kicad_pcb
    attr_reader :parsed_data

    # TODO: Have variables in the parser for the following, so they can be read from the parsed file's general section and compared to the calculated values:
    # drawings_count
    # tracks_count
    # zones_count
    # modules_count
    # nets_count

    #TODO: Make parse just take a string, move the file reading out of here!!!
    #        (file reading should be in whatever /bin file calls parse)
    #        (or if it must be here, parse_file needs to be a separate method that calls parse)
    def initialize(file_to_parse = nil)
      @kicad_pcb = KicadPcb.new(set_defaults: false)
      if file_to_parse
        parse file_to_parse
      end
    end

    #TODO: Make parse just take a string, move the file reading out of here!!!
    #        (file reading should be in whatever /bin file calls parse)
    #        (or if it must be here, parse_file needs to be a separate method that calls parse)
    def parse(file_to_parse)
      # Assume something else vetted the file before passing it here.
      @parsed_data = SexprParser.parse(File.read(file_to_parse))
      # The parsed data should always start with :kicad_pcb
      unless @parsed_data[0][0] == :kicad_pcb
        raise StandardError.new 'Parser did not see :kicad_pcb as first element.'
      end
      # Iterate over everything except the first thing, which was :kicad_pcb
      @parsed_data[0].drop(1).each do |contents|
        case contents[0]
        when :version
          parse_version contents
        when :host
          parse_host contents
        when :general
          parse_general contents
        when :page
          parse_page contents
        when :layers
          parse_layers contents
        when :setup
          parse_setup contents
        when :net
          parse_net contents
        when :net_class
          parse_net_class contents
        else
          raise StandardError.new "Parser saw element it did not expect: #{contents[0].inspect}"
        end
      end
      #TODO:
      # this should:
      # - read/parse the file
      # - assign its values to @kicad_pcb
      # - compare the saved General values with the calculated ones from @kicad_pcb and warn if different
      # - return:
      #   - something truthy upon success
      #   - nil (or false?) if there was a failure to parse
      #       (or should it raise an exception?)
    end

    #TODO: Depending on how complex this is, maybe make the section parsers into their own classes??
    #        Then, the case...when will do something like:
    #          @parsers << GeneralParser.new(contents)
    #        and
    #          @parsers << LayersParser.new(contents)
    #        (and @parsers is an array)
    #        or should it do:
    #          GeneralParser.new(contents).parse
    #        and
    #          LayersParser.new(contents).parse
    #        ???
    #        or something else??
    #      How to make it add the parsed section to @kicad_pcb ?!?!?!

    def parse_version(the_list)
      puts "version with size: #{the_list.size}" #DEBUG #FIXME
    end

    def parse_host(the_list)
      puts "host with size: #{the_list.size}" #DEBUG #FIXME
    end

    def parse_general(the_list)
      puts "general with size: #{the_list.size}" #DEBUG #FIXME
      # TODO: Have instance variables for the general things, so they can be read from the parsed file's general section and compared to the calculated values
    end

    def parse_page(the_list)
      puts "page with size: #{the_list.size}" #DEBUG #FIXME
    end

    def parse_layers(the_list)
      puts "layers with size: #{the_list.size}" #DEBUG #FIXME
    end

    def parse_setup(the_list)
      puts "setup with size: #{the_list.size}" #DEBUG #FIXME
    end

    def parse_net(the_list)
      puts "net with size: #{the_list.size}" #DEBUG #FIXME
    end

    def parse_net_class(the_list)
      puts "net_class with size: #{the_list.size}" #DEBUG #FIXME
    end

  end
end
