require 'test_helper'
require 'kicad_pcb/graphic_item'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
GraphicItem = KicadPcb::GraphicItem

describe KicadPcb::GraphicItem do
#   before do
#   end

  it "raises the right exception if instantiated without any arguments" do
    exception = proc{ GraphicItem.new }.must_raise(ArgumentError)
    value(exception.message).must_equal 'wrong number of arguments (given 0, expected 1)'
  end

  it "raises the right exception if instantiated without valid :graphic_item_type in argument hash" do
    exception1 = proc{ GraphicItem.new({}) }.must_raise(ArgumentError)
    value(exception1.message).must_equal 'valid graphic_item_type not specified in hash'
    exception2 = proc{ GraphicItem.new({graphic_item_type: 'bad type'}) }.must_raise(ArgumentError)
    value(exception2.message).must_equal 'valid graphic_item_type not specified in hash'
  end

  it 'creates the right object type when :graphic_item_type is line' do
    value(GraphicItem.new({graphic_item_type: 'line'})).must_be_instance_of KicadPcb::GraphicItem::Line
    value(GraphicItem.new({graphic_item_type: :line})).must_be_instance_of KicadPcb::GraphicItem::Line
  end

  it 'creates the right object type when :graphic_item_type is circle' do
    value(GraphicItem.new({graphic_item_type: 'circle'})).must_be_instance_of KicadPcb::GraphicItem::Circle
    value(GraphicItem.new({graphic_item_type: :circle})).must_be_instance_of KicadPcb::GraphicItem::Circle
  end

  it 'creates the right object type when :graphic_item_type is text' do
    value(GraphicItem.new({graphic_item_type: 'text'})).must_be_instance_of KicadPcb::GraphicItem::Text
    value(GraphicItem.new({graphic_item_type: :text})).must_be_instance_of KicadPcb::GraphicItem::Text
  end

  it 'creates the right object type when :graphic_item_type is arc' do
    value(GraphicItem.new({graphic_item_type: 'arc'})).must_be_instance_of KicadPcb::GraphicItem::Arc
    value(GraphicItem.new({graphic_item_type: :arc})).must_be_instance_of KicadPcb::GraphicItem::Arc
  end

end

