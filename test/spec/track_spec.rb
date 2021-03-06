require 'test_helper'
require 'kicad_pcb/track'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Track = KicadPcb::Track

describe KicadPcb::Track do
#   before do
#   end

  it "raises the right exception if instantiated without any arguments" do
    exception = proc{ Track.new }.must_raise(ArgumentError)
    exception.message.must_equal 'wrong number of arguments (given 0, expected 1)'
  end

  it "raises the right exception if instantiated without valid :track_type in argument hash" do
    exception1 = proc{ Track.new({}) }.must_raise(ArgumentError)
    exception1.message.must_equal 'valid track_type not specified in hash'
    exception2 = proc{ Track.new({track_type: 'bad type'}) }.must_raise(ArgumentError)
    exception2.message.must_equal 'valid track_type not specified in hash'
  end

  it 'creates the right object type when :track_type is segment' do
    value(Track.new({track_type: 'segment'})).must_be_instance_of KicadPcb::Track::Segment
    value(Track.new({track_type: :segment})).must_be_instance_of KicadPcb::Track::Segment
  end

  it 'creates the right object type when :track_type is via' do
    value(Track.new({track_type: 'via'})).must_be_instance_of KicadPcb::Track::Via
    value(Track.new({track_type: :via})).must_be_instance_of KicadPcb::Track::Via
  end

end

