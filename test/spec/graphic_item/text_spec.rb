require 'test_helper'
require 'kicad_pcb/graphic_item/text'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Text = KicadPcb::GraphicItem::Text

describe KicadPcb::GraphicItem::Text do
#   before do
#   end

  it 'can be instantiated without any arguments' do
    value(Text.new).must_be_instance_of Text
  end

  it 'generates the correct hash with #to_h' do
    value(Text.new.to_h).must_equal Hash[text: '', at: ['', '', ''], layer: '', tstamp: '', size: ['', ''], thickness: '', justify: '']

    params1 = {text: 'INDEX', at: ['42.164', '90.17'], layer: 'F.SilkS', tstamp: '60004E1D', size: ['1', '1'], thickness: '0.15'}
    expected_hash1 = {text: 'INDEX', at: ['42.164', '90.17'], layer: 'F.SilkS', tstamp: '60004E1D', size: ['1', '1'], thickness: '0.15', justify: ''}
    value(Text.new(params1).to_h).must_equal expected_hash1

    params2 = {text: 'LLAWN.com', at: ['39.624', '89.408', '90'], layer: 'B.SilkS', size: ['2', '2'], thickness: '0.3', justify: 'mirror'}
    expected_hash2 = {text: 'LLAWN.com', at: ['39.624', '89.408', '90'], layer: 'B.SilkS', tstamp: '', size: ['2', '2'], thickness: '0.3', justify: 'mirror'}
    value(Text.new(params2).to_h).must_equal expected_hash2
  end


  it 'generates the correct s-expression with #to_sexpr' do
    value(Text.new.to_sexpr).must_equal "(gr_text  (at ) (layer )\n  (effects (font (size ) (thickness )))\n)"

    params1 = {text: 'INDEX', at: ['42.164', '90.17'], layer: 'F.SilkS', tstamp: '60004E1D', size: ['1', '1'], thickness: '0.15'}
    expected_sexpr1 = "(gr_text INDEX (at 42.164 90.17) (layer F.SilkS) (tstamp 60004E1D)\n  (effects (font (size 1 1) (thickness 0.15)))\n)"
    value(Text.new(params1).to_sexpr).must_equal expected_sexpr1

    params2 = {text: 'LLAWN.com', at: ['39.624', '89.408', '90'], layer: 'B.SilkS', size: ['2', '2'], thickness: '0.3', justify: 'mirror'}
    expected_sexpr2 = "(gr_text LLAWN.com (at 39.624 89.408 90) (layer B.SilkS)\n  (effects (font (size 2 2) (thickness 0.3)) (justify mirror))\n)"
    value(Text.new(params2).to_sexpr).must_equal expected_sexpr2

    params3 = {text: "KEEP SPACE CLEAR\nFOR POSSIBLE LEDS", at: ['48.26', '55.88', '90'], layer: 'Dwgs.User', size: ['0.75', '0.75'], thickness: '0.15'}
    expected_sexpr3 = "(gr_text \"KEEP SPACE CLEAR\\nFOR POSSIBLE LEDS\" (at 48.26 55.88 90) (layer Dwgs.User)\n  (effects (font (size 0.75 0.75) (thickness 0.15)))\n)"
    value(Text.new(params3).to_sexpr).must_equal expected_sexpr3
  end

  it "can make an equivalent Line with another Line's #to_h" do
    orig_params1 = {text: 'INDEX', at: ['42.164', '90.17'], layer: 'F.SilkS', tstamp: '60004E1D', size: ['1', '1'], thickness: '0.15'}
    orig1 = Text.new(orig_params1)
    new1 = Text.new(orig1.to_h)
    value(new1.to_h).must_equal orig1.to_h
    value(new1.to_sexpr).must_equal orig1.to_sexpr
  end

end

