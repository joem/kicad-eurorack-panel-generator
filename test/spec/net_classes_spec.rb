require 'test_helper'
require 'kicad_pcb/net_classes'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
NetClasses = KicadPcb::NetClasses

describe KicadPcb::NetClasses do
  before do
    @net_classes = NetClasses.new
  end

  it 'can be instantiated without any arguments' do
    value(@net_classes).must_be_instance_of NetClasses
  end

  it 'instantiates correctly when passed a valid hash' do
    net_class1 = {name: 'foo', description: 'bar', clearance: '0.1', trace_width: '0.01', via_dia: '0.1', via_drill: '0.1', uvia_dia: '0.1', uvia_drill: '0.1'}
    net_class2 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
    input_hash = {'foo' => net_class1, 'Default' => net_class2}
    expected_hash = {'foo' => {name: 'foo', description: 'bar', clearance: '0.1', trace_width: '0.01', via_dia: '0.1', via_drill: '0.1', uvia_dia: '0.1', uvia_drill: '0.1', nets: []}, 'Default' => {name: 'Default', description: '"This is the default net class."', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1', nets: []}}
    expected_s_expression = "(net_class foo bar\n  (clearance 0.1)\n  (trace_width 0.01)\n  (via_dia 0.1)\n  (via_drill 0.1)\n  (uvia_dia 0.1)\n  (uvia_drill 0.1)\n)\n(net_class Default \"This is the default net class.\"\n  (clearance 0.2)\n  (trace_width 0.25)\n  (via_dia 0.8)\n  (via_drill 0.4)\n  (uvia_dia 0.3)\n  (uvia_drill 0.1)\n)"
    @net_classes_from_hash = NetClasses.new(input_hash)
    value(@net_classes_from_hash.size).must_equal 2
    value(@net_classes_from_hash.to_h).must_equal expected_hash
    value(@net_classes_from_hash.to_sexpr).must_equal expected_s_expression
  end

  it "can make an equivalent NetClasses with another NetClasses's #to_h" do
    net_class1 = {name: 'foo', description: 'bar', clearance: '0.1', trace_width: '0.01', via_dia: '0.1', via_drill: '0.1', uvia_dia: '0.1', uvia_drill: '0.1'}
    net_class2 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
    orig = NetClasses.new({'foo' => net_class1, 'Default' => net_class2})
    new = NetClasses.new(orig.to_h)
    value(new.size).must_equal orig.size
    value(new.to_h).must_equal orig.to_h
    value(new.to_sexpr).must_equal orig.to_sexpr
  end

  it 'has a #add_default_net_class method' do
    value(@net_classes).must_respond_to :add_default_net_class
  end

  describe '#add_default_net_class' do
    it 'adds the default net class' do
      @net_classes.add_default_net_class
      value(@net_classes.size).must_equal 1
      value(@net_classes['Default'].to_sexpr).must_equal "(net_class Default \"This is the default net class.\"\n  (clearance 0.2)\n  (trace_width 0.25)\n  (via_dia 0.8)\n  (via_drill 0.4)\n  (uvia_dia 0.3)\n  (uvia_drill 0.1)\n)"
      value(@net_classes['Default'].to_h).must_equal Hash[name: 'Default', description: '"This is the default net class."', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1', nets: []]
    end
  end

  it 'has a #add_net_class method' do
    value(@net_classes).must_respond_to :add_net_class
  end

  describe '#add_net_class' do
    it 'changes the internal array' do
      #TODO: Maybe make this just test size instead of going for instance variables?
      intial_internal_variable1 = @net_classes.instance_variable_get(:@net_classes).dup
      @net_classes.add_net_class({name: 'foo',})
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable1
      intial_internal_variable2 = @net_classes.instance_variable_get(:@net_classes).dup
      @net_classes.add_net_class({name: 'bar',})
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable1
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable2
      intial_internal_variable3 = @net_classes.instance_variable_get(:@net_classes).dup
      @net_classes.add_net_class({name: 'baz',})
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable1
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable2
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable3
      intial_internal_variable4 = @net_classes.instance_variable_get(:@net_classes).dup
      @net_classes.add_net_class({name: 'buzzzz',})
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable1
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable2
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable3
      value(@net_classes.instance_variable_get(:@net_classes)).wont_equal intial_internal_variable4
    end
    it 'adds a net class if passed net data' do
      @net_classes.add_net_class({name: 'foo',})
      value(@net_classes.instance_variable_get(:@net_classes)['foo']).must_be_instance_of KicadPcb::NetClass
    end
    #it 'can chain multiple calls together' do
    #  @net_classes.set_net({number: '0', name: '""'}).set_net({number: '1', name: 'foo'})
    #  value(@net_classes.size).must_equal 2
    #  @net_classes.set_net({number: '2', name: 'bar'}).set_net({number: '3', name: 'bazzzzz'}).set_net({number: '4', name: 'fizzbuzz'})
    #  value(@net_classes.size).must_equal 5
    #end
    #TODO: Anything else I need to test of this??
  end

  it 'has a #net_classes method' do
    value(@net_classes).must_respond_to :net_classes
  end

  describe '#net_classes' do
    it 'returns an Hash' do
      value(@net_classes.net_classes).must_be_instance_of Hash
    end
    it 'returns the internal @net_classes instance variable' do
      internal_instance_variable1 = @net_classes.instance_variable_get(:@net_classes).dup
      value(@net_classes.net_classes).must_equal internal_instance_variable1
      @net_classes.add_net_class({name: 'test', description: 'foo'})
      internal_instance_variable2 = @net_classes.instance_variable_get(:@net_classes).dup
      value(@net_classes.net_classes).must_equal internal_instance_variable2
    end
  end

  ##it 'has a #to_a method' do
  ##  value(@net_classes).must_respond_to :to_a
  ##end

  ##describe '#to_a' do
  ##  it 'returns an Array' do
  ##    value(@net_classes.net_classes).must_be_instance_of Array
  ##  end
  ##  it 'returns an array of Hashes' do
  ##    @net_classes.set_net({number: '0', name: '""'})
  ##    value(@net_classes.to_a[0]).must_be_instance_of Hash
  ##  end
  ##end

  it 'has a #to_h method' do
    value(@net_classes).must_respond_to :to_h
  end

  describe '#to_h' do
    it 'returns a Hash' do
      value(@net_classes.to_h).must_be_instance_of Hash
    end
    it 'returns an hash with Hashes for values' do
      @net_classes.add_net_class({name: 'test', description: 'foo'})
      value(@net_classes.to_h['test']).must_be_instance_of Hash
      net_class_hash = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
      @net_classes.add_net_class(net_class_hash)
      value(@net_classes.to_h['test']).must_be_instance_of Hash
      value(@net_classes.to_h['Default']).must_be_instance_of Hash
    end
    it "uses the :name's as the keys" do
      @net_classes.add_net_class({name: 'test', description: 'foo'})
      value(@net_classes.to_h.keys).must_equal ['test']
      @net_classes.add_net_class({name: 'Default', description: 'bar'})
      value(@net_classes.to_h.keys.sort).must_equal ['test', 'Default'].sort
      @net_classes.add_net_class({name: 'test2', description: 'baz'})
      value(@net_classes.to_h.keys.sort).must_equal ['test', 'Default', 'test2'].sort
    end
  end

  it 'has a #to_sexpr method' do
    value(@net_classes).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do
    it 'returns a String' do
      value(@net_classes.to_sexpr).must_be_instance_of String
    end
    it 'calls #to_sexpr on the net_classes' do
      # skip #FIXME: Not sure why this doesn't work right:
      net_class_hash = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
      # @net_classes.add_net_class({name: 'test', description: 'foo'})
      @net_classes.add_net_class(net_class_hash)
      expected_s_expression1 = @net_classes.instance_variable_get(:@net_classes)['Default'].to_sexpr
      value(@net_classes.to_sexpr).must_equal expected_s_expression1
    end
    it 'joins multiple graphic items s-expressions with a newsegment' do
      skip #FIXME: Why can't I get a working regex going here???
      # @net_classes.add_net_class({name: 'test', description: 'foo'})
      # @net_classes.add_net_class({name: 'Default', description: 'bar'})
      # # value(@net_classes.to_sexpr).must_match(/\(.+\)\n\(.+\)/)
      # value(@net_classes.to_sexpr).must_match(/\(.+\)\n\(.+\)/)
      # @net_classes.add_net_class({name: 'test2', description: 'baz'})
      # value(@net_classes.to_sexpr).must_match(/(.+)\n(.+)\n(.+)/)
      # # value(@net_classes.to_sexpr).wont_match(/(.+)\n(.+)\n(.+)\n(.+)/)
    end
  end

  it 'has a #size method' do
    value(@net_classes).must_respond_to :size
  end

  describe '#size' do
    it 'returns 0 for empty NetClasses object' do
      value(@net_classes.size).must_equal 0
    end
    it 'returns correct size for non-empty NetClasses object' do
      @net_classes.add_net_class({name: 'test', description: 'foo'})
      value(@net_classes.size).must_equal 1
      @net_classes.add_net_class({name: 'Default', description: 'bar'})
      value(@net_classes.size).must_equal 2
      @net_classes.add_net_class({name: 'test2', description: 'baz'})
      value(@net_classes.size).must_equal 3
      @net_classes.add_net_class({name: 'test3', description: 'buzzzzz'})
      value(@net_classes.size).must_equal 4
    end
  end

  it 'has a #length method' do
    value(@net_classes).must_respond_to :length
  end

  describe '#length' do
    it 'returns the same thing as #size' do
      value(@net_classes.length).must_equal @net_classes.size
      @net_classes.add_net_class({name: 'test', description: 'foo'})
      value(@net_classes.length).must_equal @net_classes.size
      @net_classes.add_net_class({name: 'Default', description: 'bar'})
      value(@net_classes.length).must_equal @net_classes.size
      @net_classes.add_net_class({name: 'test2', description: 'baz'})
      value(@net_classes.length).must_equal @net_classes.size
      @net_classes.add_net_class({name: 'test3', description: 'buzzzzz'})
      value(@net_classes.length).must_equal @net_classes.size
    end
  end

  it 'has a #each method' do
    value(@net_classes).must_respond_to :each
  end
  #TODO: Should I test this method??

  it 'has a #include? method' do
    value(@net_classes).must_respond_to :include?
  end
  #TODO: Should I test this method??

  it 'has a #delete method' do
    value(@net_classes).must_respond_to :delete
  end
  #TODO: Should I test this method??

  it 'has a #[] method' do
    value(@net_classes).must_respond_to :[]
  end
  #TODO: Should I test this method??

end

