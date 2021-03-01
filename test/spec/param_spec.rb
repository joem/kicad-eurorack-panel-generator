require 'test_helper'
require 'kicad_pcb/param'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Param = KicadPcb::Param

describe KicadPcb::Param do
#   before do
#   end

  it 'can create new Param object from #[] class method' do
    value(Param[1]).must_be_instance_of Param
    value(Param['foo']).must_be_instance_of Param
    value(Param[[1,2,'bar']]).must_be_instance_of Param
  end

  it 'can create new Param object without an initial stored param' do
    value(Param[]).must_be_instance_of Param
    value(Param.new).must_be_instance_of Param
  end

  it 'calls Render#render_value on the stored param when #render is called' do
    skip('Test not implemented yet.') #FIXME
  end

  it 'calls Render#render_value on the stored param when #to_s is called' do
    skip('Test not implemented yet.') #FIXME
  end

  it 'calls renders the value when in string interpolation' do
    value("foo #{Param[1]} bar").must_equal 'foo 1 bar'
    value("foo #{Param["hello"]} bar").must_equal 'foo hello bar'
    value("foo #{Param["one two"]} bar").must_equal 'foo "one two" bar'
    value("foo #{Param[]} bar").must_equal 'foo  bar'
    value("foo #{Param[nil]} bar").must_equal 'foo  bar'
  end

  it 'returns the stored param when #raw is called' do
    skip('Test not implemented yet.') #FIXME
  end

  it 'updates the stored param via #set(new_param)' do
    skip('Test not implemented yet.') #FIXME
  end

  it 'tells you if the param is nil with #nil?' do
    value(Param[nil].nil?).must_equal true
    value(Param[].nil?).must_equal true
    value(Param[''].nil?).wont_equal true
  end

  it 'tells you if the param is not nil with #not_nil?' do
    value(Param[nil].not_nil?).must_equal false
    value(Param[].not_nil?).must_equal false
    value(Param[''].not_nil?).must_equal true
    value(Param[123].not_nil?).must_equal true
    value(Param['foo'].not_nil?).must_equal true
    value(Param['foo bar'].not_nil?).must_equal true
  end

  it 'tells you if the param is present with #present?' do
    value(Param[nil].present?).must_equal false
    value(Param[].present?).must_equal false
    value(Param[''].present?).must_equal true
    value(Param[123].present?).must_equal true
    value(Param['foo'].present?).must_equal true
    value(Param['foo bar'].present?).must_equal true
  end

  it 'returns an Array when #to_a is called' do
    value(Param[].to_a).must_be_instance_of Array
    value(Param[1].to_a).must_be_instance_of Array
    value(Param['foobar'].to_a).must_be_instance_of Array
    value(Param[['foo', 'bar']].to_a).must_be_instance_of Array
  end

  it "returns a one-element Array when param isn't an array and #to_a is called" do
    value(Param[].to_a.size).must_equal 1
    value(Param[1].to_a.size).must_equal 1
    value(Param['foobar'].to_a.size).must_equal 1
  end

  it 'returns the param array when param is an Array and #to_a is called' do
    value(Param[['foo', 'bar']].to_a).must_equal ['foo', 'bar']
    value(Param[['foo', 'bar', 'baz']].to_a).must_equal ['foo', 'bar', 'baz']
    # value(Param[['foo', ['bar', 'baz']]].to_a).must_equal ['foo', ['bar', 'baz']] # Actually returns ["foo", "[\"bar\", \"baz\"]"] ???
  end

  it 'performs #to_s on all array elements when param is an Array and #to_a is called' do
    value(Param[['foo', 'bar']].to_a).must_equal ['foo', 'bar']
    value(Param[[:foo, :bar]].to_a).must_equal ['foo', 'bar']
    value(Param[[2, 4, 8]].to_a).must_equal ['2', '4', '8']
    value(Param[[Param[2], Param['foo'], Param[:bar], :baz]].to_a).must_equal ['2', 'foo', 'bar', 'baz']
  end


  describe '#ensure_really_empty_if_empty' do
    it 'returns a Param' do
      value(Param.ensure_really_empty_if_empty(nil)).must_be_instance_of Param
      value(Param.ensure_really_empty_if_empty(1)).must_be_instance_of Param
      value(Param.ensure_really_empty_if_empty('')).must_be_instance_of Param
      value(Param.ensure_really_empty_if_empty('foo')).must_be_instance_of Param
      value(Param.ensure_really_empty_if_empty(Param['bar'])).must_be_instance_of Param
    end
    it 'returns an empty Param if instantiated with an empty input' do
      value(Param.ensure_really_empty_if_empty(nil).empty?).must_equal true
      value(Param.ensure_really_empty_if_empty('').empty?).must_equal true
      value(Param.ensure_really_empty_if_empty([]).empty?).must_equal true
      value(Param.ensure_really_empty_if_empty(Array.new).empty?).must_equal true
      value(Param.ensure_really_empty_if_empty({}).empty?).must_equal true
      value(Param.ensure_really_empty_if_empty(Hash.new).empty?).must_equal true
    end
    it 'renders to an empty string if instantiated with an empty input' do
      value(Param.ensure_really_empty_if_empty(nil).to_s).must_equal ''
      value(Param.ensure_really_empty_if_empty('').to_s).must_equal ''
      value(Param.ensure_really_empty_if_empty([]).to_s).must_equal ''
      value(Param.ensure_really_empty_if_empty(Array.new).to_s).must_equal ''
      # value(Param.ensure_really_empty_if_empty({}).to_s).must_equal '' #FIXME: Why don't these pass???
      # value(Param.ensure_really_empty_if_empty(Hash.new).to_s).must_equal '' #FIXME: Why don't these pass???
    end
    it 'returns a non-empty Param if instantiated with an non-mepty input' do
      value(Param.ensure_really_empty_if_empty('foo').empty?).must_equal false
      value(Param.ensure_really_empty_if_empty(' ').empty?).must_equal false
      value(Param.ensure_really_empty_if_empty([1]).empty?).must_equal false
      value(Param.ensure_really_empty_if_empty(2).empty?).must_equal false
      value(Param.ensure_really_empty_if_empty(0).empty?).must_equal false
    end
  end


  describe '#current_timestamp' do
    #TODO: Write some tests!!!
    it 'does something' do
      skip('Test not implemented yet.') #FIXME
    end
  end


  describe '#current_tstamp' do
    #TODO: Write some tests!!!
    it 'does something' do
      skip('Test not implemented yet.') #FIXME
    end
  end


  describe '#timestamp' do
    #TODO: Write some tests!!!
    it 'does something' do
      skip('Test not implemented yet.') #FIXME
    end
  end

end

#TODO: Test the timestamp class methods! ensure they return Param objects. Ensure they do the timestamp stuff right?

#TODO: Test the reversibility of Param (like make a param from a string, then do a to_s, then make a param again, etc)

#TODO: test with the following types of values? Or is that too redundant of the Render tests?? I guess just knowing it calls Render#render_value should be enough?

# 0 
# 1 
# 2 
# 10
# 11
# 12
# ""
# GND
# +5V
# -12V
# -5V
# "Net-(J1-PadT)"
# "Net-(J1-PadTN)"
# /front_D
# /front_C
# 3.2
# 0.051
# 0.25
# FFFFFF7F
# 0x010f0_ffffffff
# true
# false
# 15.000000
# "gerbers/"
# Default
# "This is the default net class."
# F.Paste
# B.SilkS
# *.Cu
# *.Mask
# ${KISYS3DMOD}/Button_Switch_THT.3dshapes/SW_PUSH_6mm_H9.5mm.wrl


