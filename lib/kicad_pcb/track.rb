# require_relative 'render'
require_relative 'track/segment'
require_relative 'track/via'

# This class exists only to initialize a Segment or Via object, depending on the input.

class KicadPcb
  class Track

    # include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    def self.new(track_hash)
      if track_hash[:track_type].to_s == 'segment'
        # make a Segment
        Segment.new(track_hash)
      elsif track_hash[:track_type].to_s == 'via'
        # make a Via
        Via.new(track_hash)
      end #TODO: Should there be an `else`?
    end

    # def initialize(track_hash)
    # end

    # def to_sexpr
    # end

  end
end

#  (segment (start 35.433 31.369) (end 31.623 27.559) (width 1) (layer F.Cu) (net 3))
#  (segment (start 54.102 29.972) (end 44.323 29.972) (width 1) (layer F.Cu) (net 3) (tstamp 600040F6))
#  (segment (start 35.814 31.75) (end 35.433 31.369) (width 1) (layer F.Cu) (net 3))
#  (segment (start 44.323 29.972) (end 42.545 31.75) (width 1) (layer F.Cu) (net 3))
#  (segment (start 57.912 33.782) (end 54.102 29.972) (width 1) (layer F.Cu) (net 3))
#  (segment (start 42.545 31.75) (end 35.814 31.75) (width 1) (layer F.Cu) (net 3))
#  (segment (start 62.103 33.782) (end 57.912 33.782) (width 1) (layer F.Cu) (net 3))

#  (via (at 48.133 48.006) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 4) (tstamp 5F6784AA))
#  (via (at 62.611 27.559) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 21))
#  (via (at 60.452 66.167) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 23))

