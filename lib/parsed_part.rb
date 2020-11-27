module ParsedPart

  # Parts that we know will protrude through the front panel
  #
  # x_off and y_off are the x- and y-offsets that the center of the panel hole
  # for the part is away from the :at position, when part is at 0 degrees
  # rotation.
  #
  # x_off, y_off, and hole_size are all specified in mm.
  #
  KNOWN_GOOD_PARTS = {
    'Button_Switch_THT:SW_PUSH_6mm_H7.3mm' => {
      x_off: nil, #FIXME: Set this value!
      y_off: nil, #FIXME: Set this value!
      hole_size: nil #FIXME: Set this value!
    },
    'Button_Switch_THT:SW_PUSH_6mm_H9.5mm' => {
      x_off: nil, #FIXME: Set this value!
      y_off: nil, #FIXME: Set this value!
      hole_size: nil #FIXME: Set this value!
    },
    'Connector_Audio:Jack_3.5mm_QingPu_WQP-PJ398SM_Vertical_CircularHoles' => {
      x_off: nil, #FIXME: Set this value!
      y_off: nil, #FIXME: Set this value!
      hole_size: nil #FIXME: Set this value!
    },
    'LED_THT:LED_D1.8mm_W3.3mm_H2.4mm' => {
      x_off: nil, #FIXME: Set this value!
      y_off: nil, #FIXME: Set this value!
      hole_size: nil #FIXME: Set this value!
    },
    'Potentiometer_THT:Potentiometer_Alpha_RD901F-40-00D_Single_Vertical_CircularHoles' => {
      x_off: nil, #FIXME: Set this value!
      y_off: nil, #FIXME: Set this value!
      hole_size: nil #FIXME: Set this value!
    },
  }

  # Parts that don't protrude through the front panel
  SKIPPABLE_PARTS = [
    'Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical',
    'Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical',
    'Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical',
    'MountingHole:MountingHole_3.2mm_M3_DIN965',
    'Package_DIP:DIP-8_W7.62mm',
    'Package_TO_SOT_THT:TO-92_Inline_Wide',
    'Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P2.54mm_Vertical',
    'jwm_kicad_footprints_misc:C_Disc_D5.0mm_W2.5mm_P2.50mm_LZX',
    'jwm_kicad_footprints_misc:D_P7.62mm_Horizontal_LZX',
    'jwm_kicad_footprints_misc:R_Axial_P7.62mm_Horizontal_LZX',
  ]

  class Part
    attr_accessor :reference
    attr_accessor :layer
    attr_accessor :tedit
    attr_accessor :tstamp
    attr_accessor :at
    attr_accessor :descr
    attr_accessor :tags
    attr_accessor :drawing_bits
    attr_accessor :unknown_bits
    attr_accessor :original_parsed_module

    def initialize(parsed_module)
      @drawing_bits = []
      @unknown_bits = []
      @original_parsed_module = parsed_module
      #TODO: check that [0] is :module
      @reference = parsed_module[1].to_s
      parsed_module.drop(2).each do |element|
        if element.kind_of?(Array)
          case element[0]
          when :layer
            @layer = element.drop(1)
          when :tedit
            @tedit = element.drop(1)
          when :tstamp
            @tstamp = element.drop(1)
          when :at
            @at = element.drop(1)
          when :descr
            @descr = element.drop(1)
          when :tags
            @tags = element.drop(1)
          when :fp_text
            @drawing_bits << element.drop(1)
          when :fp_circle
            @drawing_bits << element.drop(1)
          when :pad
            @drawing_bits << element.drop(1)
          else
            @unknown_bits << element # Don't drop the token for the element, in case we need it.
          end
        else
          @unknown_bits << element
        end
      end
    end

  end

end
