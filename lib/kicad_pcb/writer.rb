require_relative 'render'

class KicadPcb
  class Writer

    # If needed, refer to section 4 in this document to see the file spec: https://kicad.org/help/legacy_file_format_documentation.pdf
    # (but most of the formatting isn't done here but in the subclasses that make up the parts of the KicadPcb object)

    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def initialize(kicad_pcb_object)
      @kicad_pcb_object = kicad_pcb_object
    end

    def write
      the_output = []
      # header contains the opening parentheses (but should it???) #TODO: maybe change this?
      the_output << @kicad_pcb_object.header.to_sexpr
      the_output << conditional_newline(str: the_output.last, newlines: 2)
      # the_output << indent(@kicad_pcb_object.general.to_sexpr, 2)
      # the_output << conditional_newline(str: the_output.last)
      the_output << indent(@kicad_pcb_object.page.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last)
      the_output << indent(@kicad_pcb_object.layers.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last, newlines: 2)
      the_output << indent(@kicad_pcb_object.setup.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last, newlines: 2)
      the_output << indent(@kicad_pcb_object.nets.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last, newlines: 2)
      the_output << indent(@kicad_pcb_object.net_classes.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last, newlines: 2)
      # the_output << indent(@kicad_pcb_object.parts.to_sexpr, 2)
      # the_output << conditional_newline(str: the_output.last)
      the_output << indent(@kicad_pcb_object.graphic_items.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last, newlines: 2)
      the_output << indent(@kicad_pcb_object.tracks.to_sexpr, 2)
      the_output << conditional_newline(str: the_output.last)
      # the_output << indent(@kicad_pcb_object.zones.to_sexpr, 2)
      # the_output << conditional_newline(str: the_output.last)
      the_output << ')' # final closed parentheses on last line
      return the_output.join('')
    end

    def to_s
      write
    end


    private

    # If str, when converted to a string, isn't empty, return a specified number of newlines.
    # The default number of newlines is 1.
    def conditional_newline(str:, newlines: 1)
      if str.to_s != ''
        "\n" * newlines
      else
        ''
      end
    end

  end
end

