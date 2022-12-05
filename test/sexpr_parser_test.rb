# frozen_string_literal: true

require 'test_helper'
require 'sexpr_parser'

describe SexprParser do
#   before do
#   end

  it 'has a #parse method' do
    value(SexprParser).must_respond_to :parse
  end

  it "has private methods that can't be normally accesed from outside" do
    value(SexprParser).wont_respond_to :extract_string_literals
    value(SexprParser).wont_respond_to :tokenize_string
    value(SexprParser).wont_respond_to :restore_string_literals
    value(SexprParser).wont_respond_to :is_match?
    value(SexprParser).wont_respond_to :is_symbol?
    value(SexprParser).wont_respond_to :is_integer_literal?
    value(SexprParser).wont_respond_to :is_string_literal?
    value(SexprParser).wont_respond_to :convert_tokens
    value(SexprParser).wont_respond_to :re_structure
  end

  it "parses s-expressions into nested arrays" do
    s_expression1 = '(this (is a number 1( example "s-expression")))'
    expected_array1 = [[:this, [:is, :a, :number, 1, [:example, "s-expression"]]]]
    value(SexprParser.parse(s_expression1)).must_equal expected_array1
  end

end

