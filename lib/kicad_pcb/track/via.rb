require_relative '../render'

class KicadPcb
  class Track
    class Via

      include Render # Render contains #indent, #render_value, #render_array, and #render_hash

      # at 48.133 48.006
      # size 0.8
      # drill 0.4
      # layers F.Cu B.Cu
      # net 4
      # tstamp 5F6784AA (optional!)

      attr_accessor :at, :size, :drill, :layers, :net, :tstamp

      def initialize(via_hash = {})
        @at = Param[via_hash[:at] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @size = Param[via_hash[:size]]
        @drill = Param[via_hash[:drill]]
        @layers = Param[via_hash[:layers] || [nil,nil]] # Ensure it'll be an array if nothing was passed to it
        @net = Param[via_hash[:net]]
        @tstamp = Param.new_and_ensure_really_empty_if_empty(via_hash[:tstamp])
        @track_type = via_hash[:track_type] # Not a param that needs rendering, so don't make it a Param
      end

      def to_sexpr
        optional_tstamp = ''
        unless @tstamp.to_s.empty?
          optional_tstamp = " (tstamp #{@tstamp})"
        end
        "(via (at #{@at}) (size #{@size}) (drill #{@drill}) (layers #{@layers}) (net #{@net})#{optional_tstamp})"
      end

      def to_h
        {
          track_type: @track_type, # no need to do #to_s on this
          at: @at.to_a,
          size: @size.to_s,
          drill: @drill.to_s,
          layers: @layers.to_a,
          net: @net.to_s,
          tstamp: @tstamp.to_s
        }
      end

    end
  end
end

#  (via (at 48.133 48.006) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 4) (tstamp 5F6784AA))
#  (via (at 37.084 62.611) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 21))
#  (via (at 42.545 49.53) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 21))
#  (via (at 59.817 31.75) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 21))
#  (via (at 62.611 27.559) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 21))
#  (via (at 60.452 66.167) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 23))
#  (via (at 54.61 61.849) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 23))
#  (via (at 50.038 42.164) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 23))
#  (via (at 45.212 42.164) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 23))
#  (via (at 49.022 87.249) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 26))
#  (via (at 49.022 78.867) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 26) (tstamp 5F678628))
#  (via (at 45.212 49.022) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 26))
#  (via (at 51.689 81.28) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 27))
#  (via (at 48.895 31.369) (size 0.8) (drill 0.4) (layers F.Cu B.Cu) (net 27))

