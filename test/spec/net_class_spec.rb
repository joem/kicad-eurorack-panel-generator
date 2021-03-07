require 'test_helper'
require 'kicad_pcb/net_class'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
NetClass = KicadPcb::NetClass

describe KicadPcb::NetClass do
  before do
    @net_class = NetClass.new
  end

  it 'can be instantiated without any arguments' do
    value(@net_class).must_be_instance_of NetClass
  end

  it 'has a #add_net method' do
    value(@net_class).must_respond_to :add_net
  end

  describe '#add_net' do
    it 'increases the size of nets' do
      value(@net_class.nets.size).must_equal 0
      @net_class.add_net('+5V')
      value(@net_class.nets.size).must_equal 1
      @net_class.add_net('-12V')
      value(@net_class.nets.size).must_equal 2
      @net_class.add_net('/front_D')
      value(@net_class.nets.size).must_equal 3
      @net_class.add_net('Net-(C5-Pad2)')
      value(@net_class.nets.size).must_equal 4
    end
    it 'adds a Param to nets' do
      @net_class.add_net('+5V')
      value(@net_class.nets.last).must_be_instance_of KicadPcb::Param
      @net_class.add_net('-12V')
      value(@net_class.nets.last).must_be_instance_of KicadPcb::Param
      @net_class.add_net('/front_D')
      value(@net_class.nets.last).must_be_instance_of KicadPcb::Param
      @net_class.add_net('Net-(C5-Pad2)')
      value(@net_class.nets.last).must_be_instance_of KicadPcb::Param
    end
    it 'adds a net with the correct name' do
      @net_class.add_net('+5V')
      value(@net_class.nets.last.raw).must_equal '+5V'
      @net_class.add_net('-12V')
      value(@net_class.nets.last.raw).must_equal '-12V'
      @net_class.add_net('/front_D')
      value(@net_class.nets.last.raw).must_equal '/front_D'
      @net_class.add_net('Net-(C5-Pad2)')
      value(@net_class.nets.last.raw).must_equal 'Net-(C5-Pad2)'
    end
    it "doesn't add a net without a name" do
      @net_class.add_net('')
      value(@net_class.nets.size).must_equal 0
      @net_class.add_net(nil)
      value(@net_class.nets.size).must_equal 0
    end
    it "doesn't add a net twice" do
      @net_class.add_net('+5V')
      @net_class.add_net('+5V')
      value(@net_class.nets.size).must_equal 1
      value(@net_class.nets.last.raw).must_equal '+5V'
    end
  end

  it 'has a #to_h method' do
    value(@net_class).must_respond_to :to_h
  end

  describe '#to_h' do
    it 'returns a Hash' do
      value(@net_class.to_h).must_be_instance_of Hash
    end

    it 'generates the correct hash' do
      # No settings
      value(@net_class.to_h).must_equal Hash[name: '', description: '', clearance: '', trace_width: '', via_dia: '', via_drill: '', uvia_dia: '', uvia_drill: '', nets: []]
      # Some standard settings
      params1 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
      expected_hash1 = {name: 'Default', description: '"This is the default net class."', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1', nets: []}
      value(NetClass.new(params1).to_h).must_equal expected_hash1
      # Some standard settings and nets added
      params2 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
      expected_hash2 = {name: 'Default', description: '"This is the default net class."', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1', nets: ['+5V', '-12V']}
      net_class_with_nets = NetClass.new(params2)
      net_class_with_nets.add_net('') # This one isn't supposed to show up.
      net_class_with_nets.add_net('+5V')
      net_class_with_nets.add_net('-12V')
      value(net_class_with_nets.to_h).must_equal expected_hash2
    end
  end

  it 'has a #to_sexpr method' do
    value(@net_class).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do

    it 'generates the correct s-expression with #to_sexpr' do
      # No settings
      value(@net_class.to_sexpr).must_equal "(net_class  \n  (clearance )\n  (trace_width )\n  (via_dia )\n  (via_drill )\n  (uvia_dia )\n  (uvia_drill )\n)"
      # Some standard settings
      params1 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
      expected_sexpr1 = "(net_class Default \"This is the default net class.\"\n  (clearance 0.2)\n  (trace_width 0.25)\n  (via_dia 0.8)\n  (via_drill 0.4)\n  (uvia_dia 0.3)\n  (uvia_drill 0.1)\n)"
      value(NetClass.new(params1).to_sexpr).must_equal expected_sexpr1
      # Some standard settings and nets added
      params2 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
      expected_sexpr2 = "(net_class Default \"This is the default net class.\"\n  (clearance 0.2)\n  (trace_width 0.25)\n  (via_dia 0.8)\n  (via_drill 0.4)\n  (uvia_dia 0.3)\n  (uvia_drill 0.1)\n  (add_net +5V)\n  (add_net -12V)\n  (add_net /front_G)\n  (add_net GND)\n  (add_net \"Net-(C5-Pad2)\")\n)"
      net_class_with_nets = NetClass.new(params2)
      net_class_with_nets.add_net('') # This one isn't supposed to show up.
      net_class_with_nets.add_net('+5V')
      net_class_with_nets.add_net('-12V')
      net_class_with_nets.add_net('/front_G')
      net_class_with_nets.add_net('GND')
      net_class_with_nets.add_net('Net-(C5-Pad2)')
      value(net_class_with_nets.to_sexpr).must_equal expected_sexpr2
    end

  end

  it "can make an equivalent NetClass with another NetClass's #to_h" do
    orig_params1 = {name: 'Default', description: 'This is the default net class.', clearance: '0.2', trace_width: '0.25', via_dia: '0.8', via_drill: '0.4', uvia_dia: '0.3', uvia_drill: '0.1'}
    orig1 = NetClass.new(orig_params1)
    new1 = NetClass.new(orig1.to_h)
    value(new1.to_h).must_equal orig1.to_h
    value(new1.to_sexpr).must_equal orig1.to_sexpr
  end

  it 'has a #name method' do
    value(@net_class).must_respond_to :name
  end
  #TODO: Do I need to test this more?

  it "won't let you overwrite the name" do
    value(@net_class).wont_respond_to :name=
  end

  it 'has a #nets method' do
    value(@net_class).must_respond_to :nets
  end
  #TODO: Do I need to test this more?

  it "won't let you overwrite the nets" do
    value(@net_class).wont_respond_to :nets=
  end

  it 'has a #description method' do
    value(@net_class).must_respond_to :description
  end
  #TODO: Do I need to test this more?

  it 'has a #clearance method' do
    value(@net_class).must_respond_to :clearance
  end
  #TODO: Do I need to test this more?

  it 'has a #trace_width method' do
    value(@net_class).must_respond_to :trace_width
  end
  #TODO: Do I need to test this more?

  it 'has a #via_dia method' do
    value(@net_class).must_respond_to :via_dia
  end
  #TODO: Do I need to test this more?

  it 'has a #via_drill method' do
    value(@net_class).must_respond_to :via_drill
  end
  #TODO: Do I need to test this more?

  it 'has a #uvia_dia method' do
    value(@net_class).must_respond_to :uvia_dia
  end
  #TODO: Do I need to test this more?

  it 'has a #uvia_drill method' do
    value(@net_class).must_respond_to :uvia_drill
  end
  #TODO: Do I need to test this more?


end



