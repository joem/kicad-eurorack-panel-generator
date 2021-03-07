require 'test_helper'
require 'kicad_pcb/nets'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Nets = KicadPcb::Nets

describe KicadPcb::Nets do
  before do
    @nets = Nets.new
  end

  it 'can be instantiated without any arguments' do
    value(@nets).must_be_instance_of Nets
  end

  it 'instantiates correctly when passed a valid hash' do
    net1 = {number: '0', name: ''}
    net2 = {number: '1', name: 'foo'}
    input_hash = {0 => net1, 1 => net2}
    expected_hash = {'0' => {number: '0', name: '""'}, '1' => {number: '1', name: 'foo'}}
    expected_s_expression = "(net 0 \"\")\n(net 1 foo)"
    @nets_from_hash = Nets.new(input_hash)
    value(@nets_from_hash.size).must_equal 2
    value(@nets_from_hash.to_h).must_equal expected_hash
    value(@nets_from_hash.to_sexpr).must_equal expected_s_expression
  end

  it "can make an equivalent Nets with another Nets's #to_h" do
    net1 = {number: '0', name: ''}
    net2 = {number: '1', name: 'foo'}
    orig = Nets.new({0 => net1, 1 => net2})
    new = Nets.new(orig.to_h)
    value(new.size).must_equal orig.size
    value(new.to_h).must_equal orig.to_h
    value(new.to_sexpr).must_equal orig.to_sexpr
  end

  it 'has a #set_net method' do
    value(@nets).must_respond_to :set_net
  end

  describe '#set_net' do
    it 'changes the internal array' do
      #TODO: Maybe make this just test size instead of going for instance variables?
      intial_internal_variable1 = @nets.instance_variable_get(:@nets).dup
      @nets.set_net({number: '0', name: ''})
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable1
      intial_internal_variable2 = @nets.instance_variable_get(:@nets).dup
      @nets.set_net({number: '1', name: 'foo'})
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable1
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable2
      intial_internal_variable3 = @nets.instance_variable_get(:@nets).dup
      @nets.set_net({number: '2', name: 'bar'})
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable1
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable2
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable3
      intial_internal_variable4 = @nets.instance_variable_get(:@nets).dup
      @nets.set_net({number: '3', name: 'bazzzzz'})
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable1
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable2
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable3
      value(@nets.instance_variable_get(:@nets)).wont_equal intial_internal_variable4
    end
    it 'adds a net if passed net data' do
      @nets.set_net({number: '0', name: ''})
      value(@nets.instance_variable_get(:@nets)['0']).must_be_instance_of KicadPcb::Net
    end
    it 'can chain multiple calls together' do
      @nets.set_net({number: '0', name: ''}).set_net({number: '1', name: 'foo'})
      value(@nets.size).must_equal 2
      @nets.set_net({number: '2', name: 'bar'}).set_net({number: '3', name: 'bazzzzz'}).set_net({number: '4', name: 'fizzbuzz'})
      value(@nets.size).must_equal 5
    end
    #TODO: Test overwriting a net!
  end

  it 'has a #nets method' do
    value(@nets).must_respond_to :nets
  end

  describe '#nets' do
    it 'returns an Hash' do
      value(@nets.nets).must_be_instance_of Hash
    end
    it 'returns the internal @nets instance variable' do
      internal_instance_variable1 = @nets.instance_variable_get(:@nets).dup
      value(@nets.nets).must_equal internal_instance_variable1
      @nets.set_net({number: '0', name: ''})
      internal_instance_variable2 = @nets.instance_variable_get(:@nets).dup
      value(@nets.nets).must_equal internal_instance_variable2
    end
  end

  #it 'has a #to_a method' do
  #  value(@nets).must_respond_to :to_a
  #end

  #describe '#to_a' do
  #  it 'returns an Array' do
  #    value(@nets.nets).must_be_instance_of Array
  #  end
  #  it 'returns an array of Hashes' do
  #    @nets.set_net({number: '0', name: ''})
  #    value(@nets.to_a[0]).must_be_instance_of Hash
  #  end
  #end

  it 'has a #to_h method' do
    value(@nets).must_respond_to :to_h
  end

  describe '#to_h' do
    it 'returns a Hash' do
      value(@nets.to_h).must_be_instance_of Hash
    end
    it 'returns an hash with Hashes for values' do
      @nets.set_net({number: '0', name: ''})
      value(@nets.to_h['0']).must_be_instance_of Hash
    end
    it 'uses the keys it is set with' do
      @nets.set_net({number: '0'})
      value(@nets.to_h.keys).must_equal ['0']
      @nets.set_net({number: '1'})
      value(@nets.to_h.keys).must_equal ['0','1']
      @nets.set_net({number: '5'})
      value(@nets.to_h.keys).must_equal ['0','1','5']
    end
  end

  it 'has a #to_sexpr method' do
    value(@nets).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do
    it 'returns a String' do
      value(@nets.to_sexpr).must_be_instance_of String
    end
    it 'calls #to_sexpr on the nets' do
      @nets.set_net({number: '0'})
      expected_s_expression1 = @nets.instance_variable_get(:@nets)['0'].to_sexpr
      value(@nets.to_sexpr).must_equal expected_s_expression1
    end
    it 'joins multiple graphic items s-expressions with a newsegment' do
      @nets.set_net({number: '0'})
      @nets.set_net({number: '1'})
      value(@nets.to_sexpr).must_match(/.+\n.+/)
      @nets.set_net({number: '2'})
      value(@nets.to_sexpr).must_match(/.+\n.+\n.+/)
    end
  end

  it 'has a #size method' do
    value(@nets).must_respond_to :size
  end

  describe '#size' do
    it 'returns 0 for empty Nets object' do
      value(@nets.size).must_equal 0
    end
    it 'returns correct size for non-empty Nets object' do
      @nets.set_net({number: '0'})
      value(@nets.size).must_equal 1
      @nets.set_net({number: '1'})
      value(@nets.size).must_equal 2
      @nets.set_net({number: '2'})
      value(@nets.size).must_equal 3
      @nets.set_net({number: '3'})
      value(@nets.size).must_equal 4
    end
  end

  it 'has a #length method' do
    value(@nets).must_respond_to :length
  end

  describe '#length' do
    it 'returns the same thing as #size' do
      value(@nets.length).must_equal @nets.size
      @nets.set_net({number: '0'})
      value(@nets.length).must_equal @nets.size
      @nets.set_net({number: '1'})
      value(@nets.length).must_equal @nets.size
      @nets.set_net({number: '2'})
      value(@nets.length).must_equal @nets.size
      @nets.set_net({number: '3'})
      value(@nets.length).must_equal @nets.size
    end
  end

  it 'has a #each method' do
    value(@nets).must_respond_to :each
  end
  #TODO: Should I test this method??

  it 'has a #include? method' do
    value(@nets).must_respond_to :include?
  end
  #TODO: Should I test this method??

  it 'has a #delete method' do
    value(@nets).must_respond_to :delete
  end
  #TODO: Should I test this method??

  it 'has a #[] method' do
    value(@nets).must_respond_to :[]
  end
  #TODO: Should I test this method??

end

