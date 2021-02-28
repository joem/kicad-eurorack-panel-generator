require 'test_helper'
require 'kicad_pcb/graphic_item/line'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Line = KicadPcb::GraphicItem::Line

describe KicadPcb::GraphicItem::Line do
#   before do
#   end

  it 'can be instantiated without any arguments' do
    value(Line.new).must_be_instance_of Line
  end

  it 'generates the correct hash with #to_h' do
    value(Line.new.to_h).must_equal Hash[start: ['', ''], end: ['', ''], layer: '', width: '', tstamp: '']
    params1 = {start: ['23.114', '57.658'], end: ['73.66', '57.658'], layer: 'Dwgs.User', width: '0.15', tstamp: '6000FF7D'}
    expected_hash1 = Hash[start: ['23.114', '57.658'], end: ['73.66', '57.658'], layer: 'Dwgs.User', width: '0.15', tstamp: '6000FF7D']
    value(Line.new(params1).to_h).must_equal expected_hash1 # In this case, param1 = expected_hash1, but it's not always that case.
    params2 = {start: ['35.306', '69.088'], end: ['35.306', '63.754'], layer: 'B.SilkS', width: '0.12'}
    expected_hash2 = Hash[start: ['35.306', '69.088'], end: ['35.306', '63.754'], layer: 'B.SilkS', width: '0.12', :tstamp=>'']
    value(Line.new(params2).to_h).must_equal expected_hash2
  end


  it 'generates the correct s-expression with #to_sexpr' do
    value(Line.new.to_sexpr).must_equal '(gr_line (start ) (end ) (layer ) (width ))'
    params1 = {start: ['23.114', '57.658'], end: ['73.66', '57.658'], layer: 'Dwgs.User', width: '0.15', tstamp: '6000FF7D'}
    expected_sexpr1 = '(gr_line (start 23.114 57.658) (end 73.66 57.658) (layer Dwgs.User) (width 0.15) (tstamp 6000FF7D))'
    value(Line.new(params1).to_sexpr).must_equal expected_sexpr1
    params2 = {start: ['35.306', '69.088'], end: ['35.306', '63.754'], layer: 'B.SilkS', width: '0.12'}
    expected_sexpr2 = '(gr_line (start 35.306 69.088) (end 35.306 63.754) (layer B.SilkS) (width 0.12))'
    value(Line.new(params2).to_sexpr).must_equal expected_sexpr2
  end

  it "can make an equivalent Line with another Line's #to_h" do
    orig_params1 = {start: ['23.114', '57.658'], end: ['73.66', '57.658'], layer: 'Dwgs.User', width: '0.15', tstamp: '6000FF7D'}
    orig1 = Line.new(orig_params1)
    new1 = Line.new(orig1.to_h)
    value(new1.to_h).must_equal orig1.to_h
    value(new1.to_sexpr).must_equal orig1.to_sexpr
    orig_params2 = {start: ['35.306', '69.088'], end: ['35.306', '63.754'], layer: 'B.SilkS', width: '0.12'}
    orig2 = Line.new(orig_params2)
    new2 = Line.new(orig2.to_h)
    value(new2.to_h).must_equal orig2.to_h
    value(new2.to_sexpr).must_equal orig2.to_sexpr
  end

end

