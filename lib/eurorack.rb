require 'bigdecimal'
require 'bigdecimal/util'
require_relative './sexpr_parser.rb'

module Eurorack

  #TODO: Fix this to be the pcb height that will fit between rails! As it is now I've used 3U total...
  #      - make a height_tolerance value or something like that, so it can be adjusted
  EURORACK_3U_PANEL_MAX_HEIGHT = "128.5".to_d # in mm
  EURORACK_3U_PCB_MAX_HEIGHT = "108".to_d # in mm #NOTE: 108-110 is the rec'd range I found, so add a way to override?
  EURORACK_1U_INTELLIJEL_PANEL_MAX_HEIGHT = "39.65".to_d # in mm
  EURORACK_1U_INTELLIJEL_PCB_MAX_HEIGHT = "22.5".to_d # in mm
  EURORACK_1U_PULP_LOGIC_PANEL_MAX_HEIGHT = "43.18".to_d # in mm
  EURORACK_1U_PULP_LOGIC_PCB_MAX_HEIGHT = "28.702".to_d # in mm
  EURORACK_HP = "5.08".to_d # in mm
  EURORACK_PANEL_WIDTH_REDUCTION = "0.3".to_d # in mm

  # 3U specs: http://www.doepfer.de/a100_man/a100m_e.htm
  # also: https://sdiy.info/wiki/Eurorack_DIY_parts
  # 1U specs (Intellijel): https://intellijel.com/support/1u-technical-specifications/
  # 1U specs (Pulp Logic): http://pulplogic.com/1u_tiles/

  #TODO: Is tis needed??
  def self.valid_pcb_height?(pcb_height, format = :standard_3u)
    case format
    when :standard_3u
      pcb_height.to_d <= EURORACK_3U_PCB_MAX_HEIGHT
    when :intellijel_1u
      pcb_height.to_d <= EURORACK_1U_INTELLIJEL_PCB_MAX_HEIGHT
    when :pulp_logic_1u
      pcb_height.to_d <= EURORACK_1U_PULP_LOGIC_PANEL_MAX_HEIGHT
    end
  end

  # Given a PCB width in mm, return the minimum HP that the PCB will fit in
  #
  # Input should be an Integer, Float, or BigDecimal.
  #
  # You can also optionally specify the amount the resulting width will be
  # reduced by for tolerance reasons. If not specified,
  # EURORACK_PANEL_WIDTH_REDUCTION will be used.
  #
  # Output is an Integer.
  #
  def self.minimum_hp(pcb_width_mm, reduction_mm = EURORACK_PANEL_WIDTH_REDUCTION)
    ((pcb_width_mm.to_d + reduction_mm.to_d) / EURORACK_HP).ceil.to_i
  end

  # Convert a given HP value to the width of a eurack panel in mm, leaving a little room for tolerance
  #
  # Input can be an integer (of Integer or BigDecimal type) or a string/symbol
  # representation see #extract_hp_from_symbol_or_string for formats).
  #
  # You can also optionally specify the amount the resulting width will be
  # reduced by for tolerance reasons. If not specified,
  # EURORACK_PANEL_WIDTH_REDUCTION will be used.
  #
  # Output is as a BigDecimal, to preserve floating point accuracy.
  #
  #TODO: Make this handle low HP's better... esp. 1 HP is way off from Doepfer's chart.
  def self.panel_hp_to_mm(input, reduction_mm = EURORACK_PANEL_WIDTH_REDUCTION)
    case input
    when Numeric, BigDecimal
      hp = input.to_d
    when String, Symbol
      hp = extract_hp_from_symbol_or_string(input.to_s).to_d
    else
      raise "Invalid type for hp sent to panel_hp_to_mm."
    end
    #TODO: Do the math to go from hp to mm!!!
    (hp * EURORACK_HP) - reduction_mm
  end

  # Extract the relevant HP integer from a string or symbol representation of HP.
  #
  # Input can be a string/symbol representation in any of the following
  # case-insensitive configurations:
  #   '5 hp'
  #   '5hp'
  #   'hp 5'
  #   'hp5'
  #   '5'
  #   :hp5
  #
  # Output is an Integer.
  #
  def self.extract_hp_from_symbol_or_string(eurorack_unit_string)
    case eurorack_unit_string.to_s.downcase
    when /\A\d+ ?hp\z/
      hp = eurorack_unit_string[/\A(\d+) ?hp\z/, 1].to_i
    when /\Ahp ?\d+\z/
      hp = eurorack_unit_string[/\Ahp ?(\d+)\z/, 1].to_i
    when /\A\d+\z/
      hp = eurorack_unit_string.to_i
    else
      raise "Invalid string sent to extract_hp_from_symbol_or_string."
    end
    return hp
  end

  #NOTE: To convert from BigDecimal to a string of an accurate float, use:
  # the_big_decimal.to_s("F")
  #NOTE: To convert from BigDecimal to a string of an accurate float with exactly 4 decimal places, use:
  # (the_big_decimal.to_s("F") + "0000")[ /.*\..{4}/ ]

  # # Convert a BigDecimal (or any Numeric?) to a string that shows so many decimal places (default: 4)
  # def bd_to_s(bd, places = 4)
  #   # Follows this structure: (bd.to_s("F") + "0000")[/.*\..{4}/]
  #   (bd.to_s("F") + ("0" * places))[/.*\..{#{places}}/]
  # end

end
