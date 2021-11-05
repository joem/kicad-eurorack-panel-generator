require 'test_helper'
require 'kicad_pcb/net'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
Net = KicadPcb::Net

describe KicadPcb::Net do
#   before do
#   end

  it "raises the right exception if instantiated without any arguments" do
    exception = _(proc{ Net.new }).must_raise(ArgumentError)
    value(exception.message).must_equal 'wrong number of arguments (given 0, expected 1)'
  end

  it 'has a #to_h method' do
    value(Net.new({})).must_respond_to :to_h
  end

  describe '#to_h' do

    it 'generates the correct hash' do
      params1 = {number: '0', name: '""'}
      expected_hash1 = {number: '0', name: '""'}
      value(Net.new(params1).to_h).must_equal expected_hash1
      params2 = {number: '1', name: '/SIGNAL'}
      expected_hash2 = {number: '1', name: '/SIGNAL'}
      value(Net.new(params2).to_h).must_equal expected_hash2
      params3 = {number: '2', name: 'GND'}
      expected_hash3 = {number: '2', name: 'GND'}
      value(Net.new(params3).to_h).must_equal expected_hash3
    end

  end

  it 'has a #to_sexpr method' do
    value(Net.new({})).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do

    it 'generates the correct s-expression' do
        params1 = {number: '0', name: '""'}
        expected_sexpr1 = '(net 0 "")'
        value(Net.new(params1).to_sexpr).must_equal expected_sexpr1

        params2 = {number: '1', name: '/SIGNAL'}
        expected_sexpr2 = '(net 1 /SIGNAL)'
        value(Net.new(params2).to_sexpr).must_equal expected_sexpr2

        params3 = {number: '2', name: 'GND'}
        expected_sexpr3 = '(net 2 GND)'
        value(Net.new(params3).to_sexpr).must_equal expected_sexpr3
    end

  end

  it "can make an equivalent Net with another Net's #to_h" do
    orig_params1 = {number: '0', name: '""'}
    orig1 = Net.new(orig_params1)
    new1 = Net.new(orig1.to_h)
    value(new1.to_h).must_equal orig1.to_h
    value(new1.to_sexpr).must_equal orig1.to_sexpr

    orig_params2 = {number: '1', name: '/SIGNAL'}
    orig2 = Net.new(orig_params2)
    new2 = Net.new(orig2.to_h)
    value(new2.to_h).must_equal orig2.to_h
    value(new2.to_sexpr).must_equal orig2.to_sexpr
  end

  it 'has a #number method' do
    value(Net.new({})).must_respond_to :number
  end
  #TODO: Do I need to test this?

  it 'has a #name method' do
    value(Net.new({})).must_respond_to :name
  end
  #TODO: Do I need to test this?

  it 'has a #[] method' do
    value(Net.new({})).must_respond_to :[]
  end
  #TODO: Do I need to test this?

  it 'has a #each method' do
    value(Net.new({})).must_respond_to :each
  end
  #TODO: Do I need to test this?

  it 'has a #include? method' do
    value(Net.new({})).must_respond_to :include?
  end
  #TODO: Do I need to test this?

  it 'has a #key? method' do
    value(Net.new({})).must_respond_to :key?
  end
  #TODO: Do I need to test this?

  it 'has a #keys method' do
    value(Net.new({})).must_respond_to :keys
  end
  #TODO: Do I need to test this?

  it 'has a #length method' do
    value(Net.new({})).must_respond_to :length
  end
  #TODO: Do I need to test this?

  it 'has a #size method' do
    value(Net.new({})).must_respond_to :size
  end
  #TODO: Do I need to test this?


end

