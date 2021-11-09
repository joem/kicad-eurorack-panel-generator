require_relative '../sexpr_parser.rb'
# require_relative '../kicad_pcb' # is this necessary? KicadPcb requires this file, so isn't this then circular??

class KicadPcb
  class Parser

    attr_reader :kicad_pcb
    attr_reader :parsed_data

    #TODO: Make parse just take a string, move the file reading out of here!!!
    #        (file reading should be in whatever /bin file calls parse)
    #        (or if it must be here, parse_file needs to be a separate method that calls parse)
    def initialize(file_to_parse = nil)
      @kicad_pcb = KicadPcb.new(set_defaults: false)
      # These @saved...count variables are for reading the storing what's read
      # from the General section of the parsed file. That way they can later be
      # compared to the calculated values froom @kicad_pcb.
      @saved_drawings_count = nil
      @saved_tracks_count = nil
      @saved_zones_count = nil
      @saved_modules_count = nil
      @saved_nets_count = nil
      if file_to_parse
        parse file_to_parse
      end
    end

    # this method should:
    # - parse the string
    # - assign its values to @kicad_pcb
    # - return:
    #   - something truthy upon success
    #   - nil (or false?) if there was a failure to parse
    #       (or should it raise an exception?)
    def parse(string_to_parse)
      @parsed_data = SexprParser.parse(string_to_parse)
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
      # Compare the saved General values with the calculated ones from @kicad_pcb and warn if different
      if parsed_counts_differ_from_calculated?
        $stderr.puts "Warning: The parsed counts in General differ from the calculated counts."
      end
      #TODO: make this return nil or false if any parsing errors?
      #       (or do I have exceptions that get called at the point of parsing instead?)
      return @kicad_pcb
    end

    def parse_file(file_to_parse)
      # Assume something else vetted the file before passing it here?
      #TODO: Make sure this can handle whatever normal ways a file could be passed.
      parse(File.read(file_to_parse))
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

    private

    def parsed_counts_differ_from_calculated?
      response = false # start with false
      # If any of the following inequalities is true, it turns response true.
      response ||= (@saved_drawings_count.to_s.to_i != @kicad_pcb.graphic_items.size)
      response ||= (@saved_tracks_count.to_s.to_i != @kicad_pcb.tracks.size)
      response ||= (@saved_zones_count.to_s.to_i != @kicad_pcb.zones.size)
      response ||= (@saved_modules_count.to_s.to_i != @kicad_pcb.parts.size)
      response ||= (@saved_nets_count.to_s.to_i != @kicad_pcb.nets.size)
      return response
    end

    # In the following methods, no need to check that the first element is
    # correct, since that check was already done in #parse
    # (Or maybe it's worth doing anyway, to be extra careful and make sure we
    # never call them incorrectly??)

    # In the following methods, when you need to raise an error, also show the
    # list that caused the error. Be sure to use #inspect on it so it shows the
    # raw list without formatting.

    def parse_version(the_list)
      if the_list.size != 2
        raise StandardError.new "Version parser saw wrong number of elements: #{the_list.inspect}"
      end
      @kicad_pcb.header.set_version the_list[1]
    end

    def parse_host(the_list)
      if the_list.size != 3
        raise StandardError.new "Host parser saw wrong number of elements: #{the_list.inspect}"
      end
      @kicad_pcb.header.set_host_version the_list[2]
    end

    def parse_general(the_list)
      the_list.drop(1).each do |contents|
        if contents.kind_of?(Array)
          case contents[0]
          when :thickness
            @kicad_pcb.general.set_thickness contents[1]
          when :drawings
            @saved_drawings_count = Param[contents[1]]
          when :tracks
            @saved_tracks_count = Param[contents[1]]
          when :zones
            @saved_zones_count = Param[contents[1]]
          when :modules
            @saved_modules_count = Param[contents[1]]
          when :nets
            @saved_nets_count = Param[contents[1]]
          else
            raise StandardError.new "General parser saw element it did not expect: #{contents.inspect}"
          end
        else
          raise StandardError.new "General parser saw element it did not expect: #{contents.inspect}"
        end
      end
    end

    def parse_page(the_list)
      if the_list.size != 2
        raise StandardError.new "Page parser saw wrong number of elements: #{the_list.inspect}"
      end
      @kicad_pcb.page.set_page the_list[1]
    end

    def parse_layers(the_list)
      the_list.drop(1).each do |contents|
        if contents.kind_of?(Array)
          if contents.size != 3
            raise StandardError.new "Layers parser saw wrong number of elements: #{contents.inspect}"
          end
          layer_hash = {
            number: contents[0],
            name: contents[1],
            type: contents[2]
          }
          @kicad_pcb.layers.set_layer(layer_hash)
        else
          raise StandardError.new "Layers parser saw element it did not expect: #{contents.inspect}"
        end
      end
    end

    def parse_setup(the_list)
      the_list.drop(1).each do |contents|
        if contents.kind_of?(Array)
          if contents[0] == :pcbplotparams
            contents.drop(1).each do |pcbplotparams_contents|
              if pcbplotparams_contents.size != 2
                raise StandardError.new "Setup parser saw wrong number of elements: #{pcbplotparams_contents.inspect}"
              end
              @kicad_pcb.setup[:pcbplotparams] ||= {}
              @kicad_pcb.setup[:pcbplotparams][pcbplotparams_contents[0]] = pcbplotparams_contents[1]
            end
          else
            if contents.size == 2
              @kicad_pcb.setup[contents[0]] = contents[1]
            elsif contents.size == 3
              @kicad_pcb.setup[contents[0]] = [contents[1], contents[2]]
            else
              raise StandardError.new "Setup parser saw wrong number of elements: #{contents.inspect}"
            end
          end
        else
          raise StandardError.new "Setup parser saw element it did not expect: #{contents.inspect}"
        end
      end
    end

    def parse_net(the_list)
      if the_list.size != 3
        raise StandardError.new "Net parser saw wrong number of elements: #{the_list.inspect}"
      end
      net_hash = {
        number: the_list[1],
        name: the_list[2]
      }
      @kicad_pcb.nets.set_net(net_hash)
    end

    def parse_net_class(the_list)
      #TODO: Test this with more net classes! Make sure it works, since I don't
      #       usually create more in my pcbs.
      net_class_hash = {
        name: the_list[1],
        description: the_list[2]
      }
      the_list.drop(3).each do |contents|
        if contents.kind_of?(Array)
          case contents[0]
          when :clearance
            net_class_hash[:clearance] = contents[1]
          when :trace_width
            net_class_hash[:trace_width] = contents[1]
          when :via_dia
            net_class_hash[:via_dia] = contents[1]
          when :via_drill
            net_class_hash[:via_drill] = contents[1]
          when :uvia_dia
            net_class_hash[:uvia_dia] = contents[1]
          when :uvia_drill
            net_class_hash[:uvia_drill] = contents[1]
          when :nets
            net_class_hash[:nets] = contents[1]
          else
            raise StandardError.new "Net Class parser saw element it did not expect: #{contents.inspect}"
          end
        else
          raise StandardError.new "Net Class parser saw element it did not expect: #{contents.inspect}"
        end
      end
      @kicad_pcb.net_classes.add_net_class(net_class_hash)
    end

  end
end
