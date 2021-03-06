require 'test_helper'
require 'kicad_pcb/track/segment'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Segment = KicadPcb::Track::Segment

describe KicadPcb::Track::Segment do
#   before do
#   end

  it 'can be instantiated without any arguments' do
    value(Segment.new).must_be_instance_of Segment
  end

  it 'generates the correct hash with #to_h' do
    value(Segment.new.to_h).must_equal Hash[track_type: nil, start: ['', ''], end: ['', ''], layer: '', width: '', net: '', tstamp: '']
    params1 = {start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3'}
    expected_hash1 = {track_type: nil, start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3', tstamp: ''}
    value(Segment.new(params1).to_h).must_equal expected_hash1
  end

  it 'generates the correct s-expression with #to_sexpr' do
    value(Segment.new.to_sexpr).must_equal "(segment (start ) (end ) (width ) (layer ) (net ))"

    params1 = {start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3'}
    expected_sexpr1 = '(segment (start 35.433 31.369) (end 31.623 27.559) (width 1) (layer F.Cu) (net 3))'
    value(Segment.new(params1).to_sexpr).must_equal expected_sexpr1

    params2 = {start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3'}
    expected_sexpr2 = '(segment (start 35.433 31.369) (end 31.623 27.559) (width 1) (layer F.Cu) (net 3))'
    value(Segment.new(params2).to_sexpr).must_equal expected_sexpr2
  end

  it "can make an equivalent Segment with another Segment's #to_h" do
    orig_params = {start: ['54.102', '29.972'], end: ['44.323', '29.972'], width: '1', layer: 'F.Cu', net: '3', tstamp: '600040F6'}
    orig = Segment.new(orig_params)
    new = Segment.new(orig.to_h)
    value(new.to_h).must_equal orig.to_h
    value(new.to_sexpr).must_equal orig.to_sexpr
  end

  it 'passes :track_type through to #to_h unchanged' do
    value(Segment.new({track_type: nil}).to_h[:track_type]).must_be_nil
    value(Segment.new({track_type: :segment}).to_h[:track_type]).must_equal :segment
    value(Segment.new({track_type: 'segment'}).to_h[:track_type]).must_equal 'segment'
  end

end

