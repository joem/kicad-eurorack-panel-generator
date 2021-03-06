require 'forwardable'
require_relative 'track'
require_relative 'render'

class KicadPcb
  class Tracks

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    attr_reader :tracks

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@tracks, :[], :delete, :each, :include?, :length, :size

    def initialize(tracks_hash = {})
      @tracks = []
      # If we were passed a hash, use it to set some tracks
      if tracks_hash
        tracks_hash.keys.sort.each do |index|
          add_track(tracks_hash[index])
        end
      end
    end

    def add_track(track_hash)
      @tracks << Track.new(track_hash)
      self # This lets it be chained
    end

    def to_a
      @tracks.map(&:to_h)
    end

    def to_h
      # This is a concise way of making an array into a hash where the keys are
      # the array indicies and the values are the array values:
      @tracks.map.with_index { |x, i| [i, x.to_h] }.to_h
    end

    def to_sexpr
      @tracks.map(&:to_sexpr).join("\n")
    end

  end
end

# This is the list of tracks and vias (obviously, only on copper layers) on the board.

#  (segment (start 64.77 83.055) (end 64.77 76.554949) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 60.325 87.5) (end 64.77 83.055) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 60.325 88.9) (end 60.325 87.5) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 64.77 76.554949) (end 64.77 75.565) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 43.815 65.405) (end 41.275 65.405) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 40.14363 65.405) (end 39.624 65.92463) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 41.275 65.405) (end 40.14363 65.405) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 39.624 65.92463) (end 39.624 68.834) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 39.624 68.834) (end 41.275 70.485) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 53.303 84.926) (end 44.577 76.2) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 44.577 76.2) (end 42.291 76.2) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 42.074999 71.284999) (end 41.275 70.485) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 44.577 73.787) (end 42.074999 71.284999) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 44.577 76.2) (end 44.577 73.787) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 42.251 100.2) (end 35.65 93.599) (width 1) (layer B.Cu) (net 2))
#  (segment (start 42.251 101.6) (end 42.251 100.2) (width 1) (layer B.Cu) (net 2))
#  (segment (start 35.65 93.599) (end 31.623 93.599) (width 1) (layer B.Cu) (net 2))
#  (segment (start 31.75 93.599) (end 31.75 91.059) (width 1) (layer F.Cu) (net 2))
#  (segment (start 42.251 101.6) (end 51.562 101.6) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 51.562 101.6) (end 56.388 96.774) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 53.303 89.879) (end 56.388 92.964) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 53.303 84.926) (end 53.303 89.879) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 56.388 96.774) (end 56.388 92.964) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 56.388 92.964) (end 60.452 88.9) (width 0.5) (layer F.Cu) (net 2))
#  (segment (start 35.433 31.369) (end 31.623 27.559) (width 1) (layer F.Cu) (net 3))
#  (segment (start 54.102 29.972) (end 44.323 29.972) (width 1) (layer F.Cu) (net 3) (tstamp 600040F6))
#  (segment (start 35.814 31.75) (end 35.433 31.369) (width 1) (layer F.Cu) (net 3))
#  (segment (start 44.323 29.972) (end 42.545 31.75) (width 1) (layer F.Cu) (net 3))
#  (segment (start 57.912 33.782) (end 54.102 29.972) (width 1) (layer F.Cu) (net 3))
#  (segment (start 42.545 31.75) (end 35.814 31.75) (width 1) (layer F.Cu) (net 3))
#  (segment (start 62.103 33.782) (end 57.912 33.782) (width 1) (layer F.Cu) (net 3))
#  (segment (start 60.745 41.895) (end 56.784 41.895) (width 0.75) (layer F.Cu) (net 4))
#  (segment (start 56.784 41.895) (end 56.657 41.895) (width 0.5) (layer F.Cu) (net 4))
#  (segment (start 56.657 41.895) (end 53.975 44.577) (width 0.75) (layer F.Cu) (net 4))
#  (segment (start 54.483 39.624) (end 54.483 33.782) (width 0.75) (layer F.Cu) (net 4))
#  (via (at 48.133 48.006) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 4) (tstamp 5F6784AA))
#  (segment (start 48.133 48.006) (end 35.433 48.006) (width 0.75) (layer F.Cu) (net 4))
#  (segment (start 53.975 44.577) (end 50.546 48.006) (width 0.75) (layer B.Cu) (net 4))
#  (segment (start 50.546 48.006) (end 48.133 48.006) (width 0.75) (layer B.Cu) (net 4))
#  (segment (start 35.433 48.006) (end 32.385 51.054) (width 0.75) (layer F.Cu) (net 4))
#  (segment (start 54.483 39.624) (end 56.769 41.91) (width 0.75) (layer F.Cu) (net 4))
#  (segment (start 51.562 34.163) (end 54.229 34.163) (width 0.5) (layer F.Cu) (net 4))
#  (segment (start 54.229 34.163) (end 54.356 34.036) (width 0.5) (layer F.Cu) (net 4))
#  (segment (start 39.751 17.81) (end 44.674 17.81) (width 0.5) (layer F.Cu) (net 5))
#  (segment (start 44.674 17.81) (end 45.974 16.51) (width 0.5) (layer F.Cu) (net 5))

