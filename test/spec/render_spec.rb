require 'test_helper'
require 'kicad_pcb/render'

#TODO: test render_value for the following types of values:

describe Render do
  before do
    class SimpleClass
      include Render
    end
    @test_object = SimpleClass.new
  end

  it 'has a private method #render_value' do
    value(Render.private_method_defined? :render_value).must_equal true
  end

  it 'has a private method #render_array' do
    value(Render.private_method_defined? :render_array).must_equal true
  end

  it 'has a private method #render_hash' do
    value(Render.private_method_defined? :render_hash).must_equal true
  end

  it 'correctly formats positive whole numbers' do
    value(@test_object.send(:render_value, 0)).must_equal "0"
    value(@test_object.send(:render_value, 1)).must_equal "1"
    value(@test_object.send(:render_value, 2)).must_equal "2"
    value(@test_object.send(:render_value, 10)).must_equal "10"
    value(@test_object.send(:render_value, 11)).must_equal "11"
    value(@test_object.send(:render_value, 12)).must_equal "12"
    value(@test_object.send(:render_value, 123)).must_equal "123"
    value(@test_object.send(:render_value, 34567)).must_equal "34567"
    value(@test_object.send(:render_value, 9876543210)).must_equal "9876543210"
  end

  it 'correctly formats positive decimal numbers' do
    value(@test_object.send(:render_value, 5.5)).must_equal "5.5"
# 3.2
# 0.051
# 0.25
  end

  #TODO: Test for decimal places when they're 0, like in 15.0000 (I'm not sure what should happen!)

  it 'correctly formats negative whole numbers' do
    value(@test_object.send(:render_value, -1)).must_equal "-1"
    value(@test_object.send(:render_value, -2)).must_equal "-2"
    value(@test_object.send(:render_value, -10)).must_equal "-10"
  end

  it 'correctly formats number strings' do
    value(@test_object.send(:render_value, "0")).must_equal "0"
    value(@test_object.send(:render_value, "5.5")).must_equal "5.5"
  end

  it 'correctly formats strings with spaces' do
    #TODO: Change this to test that it quotes it
    skip
  end

  it 'correctly formats strings without spaces' do
    #TODO: Change this to test that it doesn't quote it
    skip
  end

  #TODO: Test BigDecimals
  
  #TODO: Test Arrays

  #TODO: Test Hashes

end


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


