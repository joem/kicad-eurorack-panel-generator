# frozen_string_literal: true

# This is based on http://thingsaaronmade.com/blog/writing-an-s-expression-parser-in-ruby.html
# I turned it into a simple module.

module SexprParser

  # parse s-expressions
  def self.parse(string)
    string, string_literals = extract_string_literals(string)
    token_array = tokenize_string(string)
    token_array = restore_string_literals(token_array, string_literals)
    token_array = convert_tokens(token_array)
    s_expression = re_structure(token_array)[1]
    return s_expression
  end

  # Private methods below

  # Find all of the string literals, copy them into an array, and then replace
  # them with a special placeholder string, so that tokens inside literals don't
  # mess up the parsing
  def self.extract_string_literals(string)
    string_literal_pattern = /"([^"\\]|\\.)*"/
    string_replacement_token = '___+++STRING_LITERAL+++___'
    # Find and extract all the string literals
    string_literals = []
    string.gsub(string_literal_pattern) { |x| string_literals << x }
    # Replace all the string literals with our special placeholder token
    string = string.gsub(string_literal_pattern, string_replacement_token)
    # Return the modified string and the array of string literals
    return [string, string_literals]
  end
  private_class_method :extract_string_literals

  # Split up the input into its individual tokens by by adding spaces around each
  # opening or closing parentheses and then splitting the string up on whitespace
  def self.tokenize_string(string)
    string = string.gsub('(', ' ( ')
    string = string.gsub(')', ' ) ')
    token_array = string.split(' ')
    return token_array
  end
  private_class_method :tokenize_string

  # add our string literals back into their correct places in the array
  def self.restore_string_literals(token_array, string_literals)
    return token_array.map do |x|
      if (x == '___+++STRING_LITERAL+++___')
        # Since we've detected that a string literal needs to be replaced we
        # will grab the first available string from the string_literals array
        string_literals.shift
      else
        # This is not a string literal so we need to just return the token as it is
        x
      end
    end
  end
  private_class_method :restore_string_literals

  # Parse tokens:

  # A helper method to take care of the repetitive stuff for us
  def self.is_match?(string, pattern)
    match = string.match(pattern)
    return false unless match

    # Make sure that the matched pattern consumes the entire token
    match[0].length == string.length
  end
  private_class_method :is_match?

  # Detect a symbol
  def self.is_symbol?(string)
    # Anything other than parentheses, single or double quote and commas
    is_match?(string, /[^\"\'\,\(\)]+/)
  end
  private_class_method :is_symbol?

  # Detect an integer literal
  def self.is_integer_literal?(string)
    # Any number of numerals optionally preceded by a plus or minus sign
    is_match?(string, /[\-\+]?[0-9]+/)
  end
  private_class_method :is_integer_literal?

  # Detect a string literal
  def self.is_string_literal?(string)
    # Any characters except double quotes
    # (except if preceded by a backslash), surrounded by quotes
    is_match?(string, /"([^"\\]|\\.)*"/)
  end
  private_class_method :is_string_literal?

  # Convert tokens to desired types
  def self.convert_tokens(token_array)
    converted_tokens = []
    token_array.each do |t|
      converted_tokens << '(' and next if t == '('
      converted_tokens << ')' and next if t == ')'
      converted_tokens << t.to_i and next if is_integer_literal?(t)
      converted_tokens << t.to_sym and next if is_symbol?(t)
      converted_tokens << eval(t) and next if is_string_literal?(t)

      # If we haven't recognized the token by now we need to raise
      # an exception as there are no more rules left to check against!
      raise StandardError, "Unrecognized token: #{t}"
    end
    return converted_tokens
  end
  private_class_method :convert_tokens

  # Recreate the structure into an array of arrays
  def self.re_structure(token_array, offset = 0)
    struct = []
    while offset < token_array.length
      if token_array[offset] == '('
        # Multiple assignment from the array that re_structure() returns
        offset, tmp_array = re_structure(token_array, offset + 1)
        struct << tmp_array
      elsif token_array[offset] == ')'
        break
      else
        struct << token_array[offset]
      end
      offset += 1
    end
    return [offset, struct]
  end
  private_class_method :re_structure

end
