require 'test_helper'
require 'kicad_pcb/graphic_item/circle'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Circle = KicadPcb::GraphicItem::Circle

describe KicadPcb::GraphicItem::Circle do
#   before do
#   end

  it 'can be instantiated without any arguments' do
    value(Circle.new).must_be_instance_of Circle
  end

  it 'generates the correct hash with #to_h' do
    # expected_result_hash1 = {:center=>["", ""], :end=>["", ""], :layer=>"", :width=>""}
    # value(Circle.new.to_h).must_equal expected_result_hash1
    value(Circle.new.to_h).must_equal Hash[center: ['', ''], end: ['', ''], layer: '', width: '']
    params1 = {center:['46.736','94.615'], end:['47.879','96.012'],layer:'Dwgs.User',width:'0.15'}
    expected_hash1 = Hash[center: ["46.736", "94.615"], end: ["47.879", "96.012"], layer: "Dwgs.User", width: "0.15"]
    value(Circle.new(params1).to_h).must_equal expected_hash1
  end

  it 'generates the correct s-expression with #to_sexpr' do
    value(Circle.new.to_sexpr).must_equal "(gr_circle (center ) (end ) (layer ) (width ))"
    params1 = {center:['46.736','94.615'], end:['47.879','96.012'],layer:'Dwgs.User',width:'0.15'}
    expected_sexpr = '(gr_circle (center 46.736 94.615) (end 47.879 96.012) (layer Dwgs.User) (width 0.15))'
    value(Circle.new(params1).to_sexpr).must_equal expected_sexpr
  end

  #TODO: Test reversibility... make a new, do a to_h, then make a new from it and see if the same (or compare to_h?)

end

