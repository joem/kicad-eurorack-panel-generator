require 'test_helper'
require 'kicad_pcb/graphic_items'

# Do this to A) make it less verbose to write the tests and B) reflect how it's used in KicadPcb:
GraphicItems = KicadPcb::GraphicItems

describe KicadPcb::GraphicItems do
  before do
    @graphic_items = GraphicItems.new
  end

  it 'can be instantiated without any arguments' do
    value(@graphic_items).must_be_instance_of GraphicItems
  end

  it 'has a #add_graphic_item method' do
    value(@graphic_items).must_respond_to :add_graphic_item
  end

  describe '#add_graphic_item' do
    it 'changes the internal array' do
      #TODO: Maybe make this just test size instead of going for instance variables?
      intial_internal_variable1 = @graphic_items.instance_variable_get(:@graphic_items).dup
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable1
      intial_internal_variable2 = @graphic_items.instance_variable_get(:@graphic_items).dup
      @graphic_items.add_graphic_item({graphic_item_type: 'circle'})
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable1
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable2
      intial_internal_variable3 = @graphic_items.instance_variable_get(:@graphic_items).dup
      @graphic_items.add_graphic_item({graphic_item_type: 'text'})
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable1
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable2
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable3
      intial_internal_variable4 = @graphic_items.instance_variable_get(:@graphic_items).dup
      @graphic_items.add_graphic_item({graphic_item_type: 'arc'})
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable1
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable2
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable3
      value(@graphic_items.instance_variable_get(:@graphic_items)).wont_equal intial_internal_variable4
    end
    it 'adds a line if passed line data' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.instance_variable_get(:@graphic_items)[0]).must_be_instance_of KicadPcb::GraphicItem::Line
    end
    it 'adds a circle if passed circle data' do
      @graphic_items.add_graphic_item({graphic_item_type: 'circle'})
      value(@graphic_items.instance_variable_get(:@graphic_items)[0]).must_be_instance_of KicadPcb::GraphicItem::Circle
    end
    it 'adds text if passed text data' do
      @graphic_items.add_graphic_item({graphic_item_type: 'text'})
      value(@graphic_items.instance_variable_get(:@graphic_items)[0]).must_be_instance_of KicadPcb::GraphicItem::Text
    end
    it 'adds an arc if passed arc data' do
      @graphic_items.add_graphic_item({graphic_item_type: 'arc'})
      value(@graphic_items.instance_variable_get(:@graphic_items)[0]).must_be_instance_of KicadPcb::GraphicItem::Arc
    end
    it 'can chain multiple calls together' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'}).add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.size).must_equal 2
      @graphic_items.add_graphic_item({graphic_item_type: 'circle'}).add_graphic_item({graphic_item_type: 'line'}).add_graphic_item({graphic_item_type: 'text'})
      value(@graphic_items.size).must_equal 5
    end
  end

  it 'has a #graphic_items method' do
    value(@graphic_items).must_respond_to :graphic_items
  end

  describe '#graphic_items' do
    it 'returns an Array' do
      value(@graphic_items.graphic_items).must_be_instance_of Array
    end
    it 'returns the internal @graphic_items instance variable' do
      internal_instance_variable1 = @graphic_items.instance_variable_get(:@graphic_items).dup
      value(@graphic_items.graphic_items).must_equal internal_instance_variable1
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      internal_instance_variable2 = @graphic_items.instance_variable_get(:@graphic_items).dup
      value(@graphic_items.graphic_items).must_equal internal_instance_variable2
    end
  end

  it 'has a #to_a method' do
    value(@graphic_items).must_respond_to :to_a
  end

  describe '#to_a' do
    it 'returns an Array' do
      value(@graphic_items.graphic_items).must_be_instance_of Array
    end
    it 'returns an array of Hashes' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.to_a[0]).must_be_instance_of Hash
    end
  end

  it 'has a #to_h method' do
    value(@graphic_items).must_respond_to :to_h
  end

  describe '#to_h' do
    it 'returns a Hash' do
      value(@graphic_items.to_h).must_be_instance_of Hash
    end
    it 'returns an hash with Hashes for values' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.to_h[0]).must_be_instance_of Hash # Note using 0 as a key works because the hash is indexed by numbers
    end
    it 'uses incrementing numerical keys' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.to_h.keys).must_equal [0]
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.to_h.keys).must_equal [0,1]
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.to_h.keys).must_equal [0,1,2]
    end
  end

  it 'has a #to_sexpr method' do
    value(@graphic_items).must_respond_to :to_sexpr
  end

  describe '#to_sexpr' do
    it 'returns a String' do
      value(@graphic_items.to_sexpr).must_be_instance_of String
    end
    it 'calls #to_sexpr on the graphic_items' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      expected_s_expression1 = @graphic_items.instance_variable_get(:@graphic_items)[0].to_sexpr
      value(@graphic_items.to_sexpr).must_equal expected_s_expression1
    end
    it 'joins multiple graphic items s-expressions with a newline' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      @graphic_items.add_graphic_item({graphic_item_type: 'circle'})
      value(@graphic_items.to_sexpr).must_match(/.+\n.+/)
      @graphic_items.add_graphic_item({graphic_item_type: 'circle'})
      value(@graphic_items.to_sexpr).must_match(/.+\n.+\n.+/)
    end
  end

  it 'has a #size method' do
    value(@graphic_items).must_respond_to :size
  end

  describe '#size' do
    it 'returns 0 for empty GraphicItems object' do
      value(@graphic_items.size).must_equal 0
    end
    it 'returns correct size for non-empty GraphicItems object' do
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.size).must_equal 1
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.size).must_equal 2
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.size).must_equal 3
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.size).must_equal 4
    end
  end

  it 'has a #length method' do
    value(@graphic_items).must_respond_to :length
  end

  describe '#length' do
    it 'returns the same thing as #size' do
      value(@graphic_items.length).must_equal @graphic_items.size
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.length).must_equal @graphic_items.size
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.length).must_equal @graphic_items.size
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.length).must_equal @graphic_items.size
      @graphic_items.add_graphic_item({graphic_item_type: 'line'})
      value(@graphic_items.length).must_equal @graphic_items.size
    end
  end

  it 'has a #each method' do
    value(@graphic_items).must_respond_to :each
  end
  #TODO: Should I test this method??

  it 'has a #include? method' do
    value(@graphic_items).must_respond_to :include?
  end
  #TODO: Should I test this method??

  it 'has a #delete method' do
    value(@graphic_items).must_respond_to :delete
  end
  #TODO: Should I test this method??

  it 'has a #[] method' do
    value(@graphic_items).must_respond_to :[]
  end
  #TODO: Should I test this method??

end

