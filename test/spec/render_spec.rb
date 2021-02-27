require 'test_helper'
require 'kicad_pcb/render'
require 'bigdecimal'
require 'bigdecimal/util'

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

  #TODO: Be more specific than 'correctly'?
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

  #TODO: Be more specific than 'correctly'?
  it 'correctly formats positive decimal numbers' do
    value(@test_object.send(:render_value, 5.5)).must_equal "5.5"
    value(@test_object.send(:render_value, 3.2)).must_equal "3.2"
    value(@test_object.send(:render_value, 0.25)).must_equal "0.25"
    value(@test_object.send(:render_value, 0.051)).must_equal "0.051"
  end

  #TODO: Test for decimal places when they're 0, like in 15.0000 (I'm not sure what should happen!)

  #TODO: Change up some of these tests to test floats and ints!

  #TODO: Be more specific than 'correctly'?
  it 'correctly formats negative whole numbers' do
    value(@test_object.send(:render_value, -1)).must_equal '-1'
    value(@test_object.send(:render_value, -2)).must_equal '-2'
    value(@test_object.send(:render_value, -10)).must_equal '-10'
  end

  #TODO: Be more specific than 'correctly'?
  it 'correctly formats number strings' do
    value(@test_object.send(:render_value, '0')).must_equal '0'
    value(@test_object.send(:render_value, '5.5')).must_equal '5.5'
  end

  it 'quotes strings with spaces' do
    value(@test_object.send(:render_value, 'a b')).must_equal '"a b"'
    value(@test_object.send(:render_value, "This is the default net class.")).must_equal '"This is the default net class."'
    value(@test_object.send(:render_value, 'this is a sample')).must_equal '"this is a sample"' # example from the docs
  end

  it 'quotes strings with tabs and endcodes the tab as \t' do
    value(@test_object.send(:render_value, "\tab")).must_equal '"\tab"'
    value(@test_object.send(:render_value, "c\td")).must_equal '"c\td"'
    value(@test_object.send(:render_value, "ef\t")).must_equal '"ef\t"'
  end

  it 'quotes strings with newlines and endcodes the newline as \n' do
    value(@test_object.send(:render_value, "\nab")).must_equal '"\nab"'
    value(@test_object.send(:render_value, "c\nd")).must_equal '"c\nd"'
    value(@test_object.send(:render_value, "ef\n")).must_equal '"ef\n"'
    value(@test_object.send(:render_value, "line 1\nline 2")).must_equal '"line 1\nline 2"' # example from the docs
  end

  it 'quotes strings with (' do
    value(@test_object.send(:render_value, '(ab')).must_equal '"(ab"'
    value(@test_object.send(:render_value, 'a(b')).must_equal '"a(b"'
    value(@test_object.send(:render_value, 'ab(')).must_equal '"ab("'
    value(@test_object.send(:render_value, '(ab)')).must_equal '"(ab)"'
    value(@test_object.send(:render_value, 'a()b')).must_equal '"a()b"'
    value(@test_object.send(:render_value, 'Net-(J1-PadT)')).must_equal '"Net-(J1-PadT)"'
   "(19"
  end

  it 'quotes strings with )' do
    value(@test_object.send(:render_value, ')ab')).must_equal '")ab"'
    value(@test_object.send(:render_value, 'a)b')).must_equal '"a)b"'
    value(@test_object.send(:render_value, 'ab)')).must_equal '"ab)"'
    value(@test_object.send(:render_value, '(foobar)')).must_equal '"(foobar)"'
    value(@test_object.send(:render_value, 'foo()bar')).must_equal '"foo()bar"'
    value(@test_object.send(:render_value, 'con(14)')).must_equal '"con(14)"' # example from the docs
  end

  it "doesn't quote strings with a dash at the beginning and nowhere else" do
    value(@test_object.send(:render_value, '-ab')).must_equal '-ab'
    value(@test_object.send(:render_value, '-CDC')).must_equal '-CDC' # example from the docs
  end

  it 'quotes strings with a dash anywhere but the front' do
    value(@test_object.send(:render_value, 'a-b')).must_equal '"a-b"'
    value(@test_object.send(:render_value, "-a-b")).must_equal '"-a-b"'
    value(@test_object.send(:render_value, 'ab-')).must_equal '"ab-"'
    value(@test_object.send(:render_value, 'Net-(J1-PadTN)')).must_equal '"Net-(J1-PadTN)"'
    value(@test_object.send(:render_value, 'C-DC')).must_equal '"C-DC"' # example from the docs
  end

  it 'quotes strings with %' do
    value(@test_object.send(:render_value, 'a%b')).must_equal '"a%b"'
    value(@test_object.send(:render_value, '99%')).must_equal '"99%"'
    value(@test_object.send(:render_value, '%foo')).must_equal '"%foo"'
  end

  it 'quotes strings with #' do
    value(@test_object.send(:render_value, 'wire#123')).must_equal '"wire#123"' # example from the docs
  end

  it 'quotes strings with {' do
    value(@test_object.send(:render_value, '{ab')).must_equal '"{ab"'
    value(@test_object.send(:render_value, 'a{b')).must_equal '"a{b"'
    value(@test_object.send(:render_value, 'ab{')).must_equal '"ab{"'
    value(@test_object.send(:render_value, '{ab}')).must_equal '"{ab}"'
    value(@test_object.send(:render_value, 'a{}b')).must_equal '"a{}b"'
  end

  it 'quotes strings with }' do
    value(@test_object.send(:render_value, '}ab')).must_equal '"}ab"'
    value(@test_object.send(:render_value, 'a}b')).must_equal '"a}b"'
    value(@test_object.send(:render_value, 'ab}')).must_equal '"ab}"'
    value(@test_object.send(:render_value, '{foobar}')).must_equal '"{foobar}"'
    value(@test_object.send(:render_value, 'foo{}bar')).must_equal '"foo{}bar"'
  end

  it 'quotes empty strings' do
    value(@test_object.send(:render_value, '')).must_equal '""'
    value(@test_object.send(:render_value, "")).must_equal '""' # super redundant, but I wanted to make it clear
  end

  it "renders nil as an empty string" do
    value(@test_object.send(:render_value, nil)).must_equal ''
    value(@test_object.send(:render_value, nil)).wont_equal '""'
  end

  it "doesn't quote strings that don't have spaces, tabs, (, ), {, }, %" do
    value(@test_object.send(:render_value, '0')).must_equal '0'
    value(@test_object.send(:render_value, '1')).must_equal '1'
    value(@test_object.send(:render_value, '2')).must_equal '2'
    value(@test_object.send(:render_value, '10')).must_equal '10'
    value(@test_object.send(:render_value, '11')).must_equal '11'
    value(@test_object.send(:render_value, '12')).must_equal '12'
    value(@test_object.send(:render_value, 'GND')).must_equal 'GND'
    value(@test_object.send(:render_value, '+5V')).must_equal '+5V'
    value(@test_object.send(:render_value, '-12V')).must_equal '-12V'
    value(@test_object.send(:render_value, '-5V')).must_equal '-5V'
    value(@test_object.send(:render_value, '/front_D')).must_equal '/front_D'
    value(@test_object.send(:render_value, '/front_C')).must_equal '/front_C'
    value(@test_object.send(:render_value, '3.2')).must_equal '3.2'
    value(@test_object.send(:render_value, '0.051')).must_equal '0.051'
    value(@test_object.send(:render_value, '0.25')).must_equal '0.25'
    value(@test_object.send(:render_value, 'FFFFFF7F')).must_equal 'FFFFFF7F'
    value(@test_object.send(:render_value, '0x010f0_ffffffff')).must_equal '0x010f0_ffffffff'
    value(@test_object.send(:render_value, 'true')).must_equal 'true'
    value(@test_object.send(:render_value, 'false')).must_equal 'false'
    value(@test_object.send(:render_value, '15.000000')).must_equal '15.000000'
    value(@test_object.send(:render_value, 'Default')).must_equal 'Default'
    value(@test_object.send(:render_value, 'F.Paste')).must_equal 'F.Paste'
    value(@test_object.send(:render_value, 'B.SilkS')).must_equal 'B.SilkS'
    value(@test_object.send(:render_value, '*.Cu')).must_equal '*.Cu'
    value(@test_object.send(:render_value, '*.Mask')).must_equal '*.Mask'
  end

  it "doesn't quote a string with embedded quotes" do
    value(@test_object.send(:render_value, 'leg"23')).must_equal 'leg"23' # example from the docs
    value(@test_object.send(:render_value, 'foo""bar')).must_equal 'foo""bar'
  end

  it 'duplicates an embedded quote if it the whole string becomes quoted' do
    value(@test_object.send(:render_value, ' leg"23 ')).must_equal '" leg""23 "' # example from the docs (kind of)
    value(@test_object.send(:render_value, ' foo""bar ')).must_equal '" foo""""bar "'
  end

  it "doesn't duplicate embedded quotes if the string is already quoted" do
    value(@test_object.send(:render_value, '"foo"bar"')).must_equal '"foo"bar"'
    value(@test_object.send(:render_value, '"foo""bar"')).must_equal '"foo""bar"'
    value(@test_object.send(:render_value, '"foo"""bar"')).must_equal '"foo"""bar"'
  end

  it "doesn't double quote an already-quoted string" do
    value(@test_object.send(:render_value, '"foo"')).must_equal '"foo"'
  end

  it 'correctly formats BigDecimals to have at least one decimal place' do
    value(@test_object.send(:render_value, '0'.to_d)).must_equal '0.0'
    value(@test_object.send(:render_value, '5.5'.to_d)).must_equal '5.5'
    value(@test_object.send(:render_value, '15.00000'.to_d)).must_equal '15.0'
    value(@test_object.send(:render_value, '15.10000'.to_d)).must_equal '15.1'
    value(@test_object.send(:render_value, '15.01000'.to_d)).must_equal '15.01'
    value(@test_object.send(:render_value, '15.00100'.to_d)).must_equal '15.001'
    value(@test_object.send(:render_value, '15.00010'.to_d)).must_equal '15.0001'
    value(@test_object.send(:render_value, '15.00001'.to_d)).must_equal '15.00001'
    value(@test_object.send(:render_value, '97235987915.7812375'.to_d)).must_equal '97235987915.7812375' # yeeeeehaaaaw!
  end

  #TODO: Test Arrays
  it 'something something Arrays' do
    skip #FIXME
  end

  #TODO: Test Hashes
  it 'something something Hashes' do
    skip #FIXME
  end

end


# 0 
# 1 
# 2 
# 10
# 11
# 12
# GND
# +5V
# -12V
# -5V
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


