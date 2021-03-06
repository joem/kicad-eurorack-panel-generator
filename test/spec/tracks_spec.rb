require 'test_helper'
require 'kicad_pcb/tracks'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Tracks = KicadPcb::Tracks

describe KicadPcb::Tracks do
  before do
    @tracks = Tracks.new
  end

  it 'can be instantiated without any arguments' do
    value(@tracks).must_be_instance_of Tracks
  end

  it 'instantiates correctly when passed a valid hash' do
    track1 = {track_type: 'via', at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}
    track2 = {track_type: 'segment', start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3'}
    input_hash = {0 => track1, 1 => track2}
    expected_hash = {0 => {track_type: 'via', at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}, 1 => {track_type: 'segment', start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3', tstamp: ''}}
    @tracks_from_hash = Tracks.new(input_hash)
    value(@tracks_from_hash.size).must_equal 2
    value(@tracks_from_hash.to_h).must_equal expected_hash
  end

  it "can make an equivalent Tracks with another Tracks's #to_h" do
    track1 = {track_type: 'via', at: ['48.133', '48.006'], size: '0.8', drill: '0.4', layers: ['F.Cu', 'B.Cu'], net: '4', tstamp: '5F6784AA'}
    track2 = {track_type: 'segment', start: ['35.433', '31.369'], end: ['31.623', '27.559'], width: '1', layer: 'F.Cu', net: '3'}
    orig = Tracks.new({0 => track1, 1 => track2})
    new = Tracks.new(orig.to_h)
    value(new.size).must_equal orig.size
    value(new.to_h).must_equal orig.to_h
    value(new.to_sexpr).must_equal orig.to_sexpr
  end

  it 'has a #add_track method' do
    value(@tracks).must_respond_to :add_track
  end

  describe '#add_track' do
    it 'changes the internal array' do
      #TODO: Maybe make this just test size instead of going for instance variables?
      intial_internal_variable1 = @tracks.instance_variable_get(:@tracks).dup
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable1
      intial_internal_variable2 = @tracks.instance_variable_get(:@tracks).dup
      @tracks.add_track({track_type: 'via'})
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable1
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable2
      intial_internal_variable3 = @tracks.instance_variable_get(:@tracks).dup
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable1
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable2
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable3
      intial_internal_variable4 = @tracks.instance_variable_get(:@tracks).dup
      @tracks.add_track({track_type: 'via'})
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable1
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable2
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable3
      value(@tracks.instance_variable_get(:@tracks)).wont_equal intial_internal_variable4
    end
    it 'adds a segment if passed segment data' do
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.instance_variable_get(:@tracks)[0]).must_be_instance_of KicadPcb::Track::Segment
    end
    it 'adds a via if passed via data' do
      @tracks.add_track({track_type: 'via'})
      value(@tracks.instance_variable_get(:@tracks)[0]).must_be_instance_of KicadPcb::Track::Via
    end
    it 'can chain multiple calls together' do
      @tracks.add_track({track_type: 'segment'}).add_track({track_type: 'segment'})
      value(@tracks.size).must_equal 2
      @tracks.add_track({track_type: 'via'}).add_track({track_type: 'via'}).add_track({track_type: 'segment'})
      value(@tracks.size).must_equal 5
    end
  end

  it 'has a #tracks method' do
    value(@tracks).must_respond_to :tracks
  end

  describe '#tracks' do
    it 'returns an Array' do
      value(@tracks.tracks).must_be_instance_of Array
    end
    it 'returns the internal @tracks instance variable' do
      internal_instance_variable1 = @tracks.instance_variable_get(:@tracks).dup
      value(@tracks.tracks).must_equal internal_instance_variable1
      @tracks.add_track({track_type: 'segment'})
      internal_instance_variable2 = @tracks.instance_variable_get(:@tracks).dup
      value(@tracks.tracks).must_equal internal_instance_variable2
    end
  end

  it 'has a #to_a method' do
    value(@tracks).must_respond_to :to_a
  end

  describe '#to_a' do
    it 'returns an Array' do
      value(@tracks.tracks).must_be_instance_of Array
    end
    it 'returns an array of Hashes' do
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.to_a[0]).must_be_instance_of Hash
    end
  end

  it 'has a #to_h method' do
    value(@tracks).must_respond_to :to_h
  end

  describe '#to_h' do
    it 'returns a Hash' do
      value(@tracks.to_h).must_be_instance_of Hash
    end
    it 'returns an hash with Hashes for values' do
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.to_h[0]).must_be_instance_of Hash # Note using 0 as a key works because the hash is indexed by numbers
    end
    it 'uses incrementing numerical keys' do
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.to_h.keys).must_equal [0]
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.to_h.keys).must_equal [0,1]
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.to_h.keys).must_equal [0,1,2]
    end
  end

  it 'has a #to_sexpr method' do
    value(@tracks).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do
    it 'returns a String' do
      value(@tracks.to_sexpr).must_be_instance_of String
    end
    it 'calls #to_sexpr on the tracks' do
      @tracks.add_track({track_type: 'segment'})
      expected_s_expression1 = @tracks.instance_variable_get(:@tracks)[0].to_sexpr
      value(@tracks.to_sexpr).must_equal expected_s_expression1
    end
    it 'joins multiple graphic items s-expressions with a newsegment' do
      @tracks.add_track({track_type: 'segment'})
      @tracks.add_track({track_type: 'via'})
      value(@tracks.to_sexpr).must_match(/.+\n.+/)
      @tracks.add_track({track_type: 'via'})
      value(@tracks.to_sexpr).must_match(/.+\n.+\n.+/)
    end
  end

  it 'has a #size method' do
    value(@tracks).must_respond_to :size
  end

  describe '#size' do
    it 'returns 0 for empty Tracks object' do
      value(@tracks.size).must_equal 0
    end
    it 'returns correct size for non-empty Tracks object' do
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.size).must_equal 1
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.size).must_equal 2
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.size).must_equal 3
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.size).must_equal 4
    end
  end

  it 'has a #length method' do
    value(@tracks).must_respond_to :length
  end

  describe '#length' do
    it 'returns the same thing as #size' do
      value(@tracks.length).must_equal @tracks.size
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.length).must_equal @tracks.size
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.length).must_equal @tracks.size
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.length).must_equal @tracks.size
      @tracks.add_track({track_type: 'segment'})
      value(@tracks.length).must_equal @tracks.size
    end
  end

  it 'has a #each method' do
    value(@tracks).must_respond_to :each
  end
  #TODO: Should I test this method??

  it 'has a #include? method' do
    value(@tracks).must_respond_to :include?
  end
  #TODO: Should I test this method??

  it 'has a #delete method' do
    value(@tracks).must_respond_to :delete
  end
  #TODO: Should I test this method??

  it 'has a #[] method' do
    value(@tracks).must_respond_to :[]
  end
  #TODO: Should I test this method??

end

