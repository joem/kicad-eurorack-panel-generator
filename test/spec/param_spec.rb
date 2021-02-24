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
    skip #FIXME
  end

  it 'calls Render#render_value on the stored param when #to_s is called' do
    skip #FIXME
  end

  it 'returns the stored param when #raw is called' do
    skip #FIXME
  end

  it 'updates the stored param via #set(new_param)' do
    skip #FIXME
  end

end


#TODO: Test the reversibility of Param

#TODO: test with the following types of values:

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


