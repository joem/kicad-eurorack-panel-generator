require 'test_helper'
require 'kicad_pcb/track/via'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Via = KicadPcb::Track::Via

describe KicadPcb::Track::Via do
#   before do
#   end

  it 'can be instantiated without any arguments' do
    value(Via.new).must_be_instance_of Via
  end

  it 'has a #to_h method' do
    value(Via.new).must_respond_to :to_h
  end

  describe '#to_h' do

    it 'generates the correct hash' do
      value(Via.new.to_h).must_equal Hash[track_type: nil, at: ['', ''], size: '', drill: '', layers: ['', ''], net: '', tstamp: '']
      params1 = {at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}
      expected_hash1 = {track_type: nil, at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}
      value(Via.new(params1).to_h).must_equal expected_hash1
    end


    it 'passes :track_type through unchanged' do
      value(Via.new({track_type: nil}).to_h[:track_type]).must_be_nil
      value(Via.new({track_type: :via}).to_h[:track_type]).must_equal :via
      value(Via.new({track_type: 'via'}).to_h[:track_type]).must_equal 'via'
    end

  end

  it 'has a #to_sexpr method' do
    value(Via.new).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do

    it 'generates the correct s-expression' do
        value(Via.new.to_sexpr).must_equal '(via (at ) (size ) (drill ) (layers ) (net ))'

        params1 = {at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}
        expected_sexpr1 = '(via (at 48.133 48.006) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 4) (tstamp 5F6784AA))'
        value(Via.new(params1).to_sexpr).must_equal expected_sexpr1

        params2 = {at: ['54.61', '61.849'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '23'}
        expected_sexpr2 = '(via (at 54.61 61.849) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 23))'
        value(Via.new(params2).to_sexpr).must_equal expected_sexpr2
    end

  end

  it "can make an equivalent Via with another Via's #to_h" do
    orig_params = {at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}
    orig = Via.new(orig_params)
    new = Via.new(orig.to_h)
    value(new.to_h).must_equal orig.to_h
    value(new.to_sexpr).must_equal orig.to_sexpr
  end


end

