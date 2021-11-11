# require_relative 'render'
require_relative 'param'

class KicadPcb
  class Page

    # include Render # Render contains #indent, #render_value, #render_array, and #render_hash
    attr_reader :page

    def initialize(page_hash_or_array = nil)
      if page_hash_or_array
        if page_hash_or_array.is_a?(Array)
          set_from_array(page_hash_or_array)
        elsif page_hash_or_array.is_a?(Hash)
          set_from_hash(page_hash_or_array)
        elsif page_hash_or_array.is_a?(NilClass)
          @page = nil
        else
          raise StandardError.new "Invalid kind of argument sent to #initialize: #{page_hash_or_array.inspect}"
        end
      else
        @page = nil
      end
    end

    def set_page(page)
      @page = Param[page]
    end

    def set_from_array(page_array)
      if page_array.size != 2
        raise StandardError.new "Page parser saw wrong number of elements: #{page_array.inspect}"
      end
      if page_array[0].to_s.downcase == 'page'
        @page = Param[page_array[1]]
      else
        raise StandardError.new "Invalid argument sent to #initialize: #{page_array.inspect}"
      end
    end
    #TODO: Make this be aliased to #set_page maybe?

    def set_from_hash(page_hash)
      unless page_hash.has_key?(:page)
        raise StandardError.new "Invalid argument sent to #initialize: #{page_hash.inspect}"
      end
      @page = Param[page_hash[:page]]
    end

    def set_defaults
      @page = Param['A4']
    end

    def to_sexpr
      "(page #{@page})"
    end

  end
end
