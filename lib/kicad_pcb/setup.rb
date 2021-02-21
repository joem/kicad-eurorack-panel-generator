require 'forwardable'
require_relative 'render'

class KicadPcb
  class Setup

    extend Forwardable # needed for the #def_delegators forwarding
    include Render # Render contains #indent, #render_value, #render_array, and #render_hash

    # Forward some Hash and Enumerable methods straight to the hash
    def_delegators :@setup, :[], :delete, :each, :include?, :key?, :length, :size

    def initialize(setup_hash = {})
      @setup = setup_hash
    end

    def set_default_setup
      @setup[:last_trace_width] = '0.25'
      @setup[:trace_clearance] = '0.2'
      @setup[:zone_clearance] = '0.508'
      @setup[:zone_45_only] = 'no'
      @setup[:trace_min] = '0.2'
      @setup[:via_size] = '0.8'
      @setup[:via_drill] = '0.4'
      @setup[:via_min_size] = '0.4'
      @setup[:via_min_drill] = '0.3'
      @setup[:uvia_size] = '0.3'
      @setup[:uvia_drill] = '0.1'
      @setup[:uvias_allowed] = 'no'
      @setup[:uvia_min_size] = '0.2'
      @setup[:uvia_min_drill] = '0.1'
      @setup[:edge_width] = '0.05'
      @setup[:segment_width] = '0.2'
      @setup[:pcb_text_width] = '0.3'
      @setup[:pcb_text_size] = ['1.5', '1.5']     #TODO: How to enforce that it's a pair??
      @setup[:mod_edge_width] = '0.12'
      @setup[:mod_text_size] = ['1', '1']         #TODO: How to enforce that it's a pair??
      @setup[:mod_text_width] = '0.15'
      @setup[:pad_size] = ['1.524', '1.524']      #TODO: How to enforce that it's a pair??
      @setup[:pad_drill] = '0.762'
      @setup[:pad_to_mask_clearance] = '0.051'
      @setup[:solder_mask_min_width] = '0.25'
      @setup[:aux_axis_origin] = ['0', '0']       #TODO: How to enforce that it's a pair??
      @setup[:visible_elements] = 'FFFFFF7F'
      @setup[:pcbplotparams] = {}
      @setup[:pcbplotparams][:layerselection] = '0x010fc_ffffffff'
      @setup[:pcbplotparams][:usegerberextensions] = false
      @setup[:pcbplotparams][:usegerberattributes] = false
      @setup[:pcbplotparams][:usegerberadvancedattributes] = false
      @setup[:pcbplotparams][:creategerberjobfile] = false
      @setup[:pcbplotparams][:excludeedgelayer] = true
      @setup[:pcbplotparams][:linewidth] = '0.150000'
      @setup[:pcbplotparams][:plotframeref] = false
      @setup[:pcbplotparams][:viasonmask] = false
      @setup[:pcbplotparams][:mode] = 1
      @setup[:pcbplotparams][:useauxorigin] = false
      @setup[:pcbplotparams][:hpglpennumber] = 1
      @setup[:pcbplotparams][:hpglpenspeed] = '20'
      @setup[:pcbplotparams][:hpglpendiameter] = '15.000000'
      @setup[:pcbplotparams][:psnegative] = false
      @setup[:pcbplotparams][:psa4output] = false
      @setup[:pcbplotparams][:plotreference] = true
      @setup[:pcbplotparams][:plotvalue] = true
      @setup[:pcbplotparams][:plotinvisibletext] = false
      @setup[:pcbplotparams][:padsonsilk] = false
      @setup[:pcbplotparams][:subtractmaskfromsilk] = false
      @setup[:pcbplotparams][:outputformat] = 1
      @setup[:pcbplotparams][:mirror] = false
      @setup[:pcbplotparams][:drillshape] = 1
      @setup[:pcbplotparams][:scaleselection] = '1'
      @setup[:pcbplotparams][:outputdirectory] = ''
      self # Without this, it just returns the return from the last assignment, which is kind of weird.
    end

    def to_sexpr
      # output the opening (setup line
      # iterate over hash and output them
      # output closing )
      output = ''
      output << '(setup'
      output << "\n"
      output << indent(render_hash(@setup), 2)
      output << "\n"
      output << ')'
      return output
    end

    def to_h
      @setup
    end

  end
end

#  (setup
#    (last_trace_width 0.5)
#    (user_trace_width 0.5)
#    (user_trace_width 0.75)
#    (user_trace_width 1)
#    (trace_clearance 0.2)
#    (zone_clearance 0.508)
#    (zone_45_only no)
#    (trace_min 0.2)
#    (via_size 0.8)
#    (via_drill 0.4)
#    (via_min_size 0.4)
#    (via_min_drill 0.3)
#    (uvia_size 0.3)
#    (uvia_drill 0.1)
#    (uvias_allowed no)
#    (uvia_min_size 0.2)
#    (uvia_min_drill 0.1)
#    (edge_width 0.05)
#    (segment_width 0.2)
#    (pcb_text_width 0.3)
#    (pcb_text_size 1.5 1.5)
#    (mod_edge_width 0.12)
#    (mod_text_size 1 1)
#    (mod_text_width 0.15)
#    (pad_size 3.2 3.2)
#    (pad_drill 3.2)
#    (pad_to_mask_clearance 0.051)
#    (solder_mask_min_width 0.25)
#    (aux_axis_origin 0 0)
#    (visible_elements FFFFFF7F)
#    (pcbplotparams
#      (layerselection 0x010f0_ffffffff)
#      (usegerberextensions true)
#      (usegerberattributes false)
#      (usegerberadvancedattributes false)
#      (creategerberjobfile false)
#      (excludeedgelayer true)
#      (linewidth 0.100000)
#      (plotframeref false)
#      (viasonmask false)
#      (mode 1)
#      (useauxorigin false)
#      (hpglpennumber 1)
#      (hpglpenspeed 20)
#      (hpglpendiameter 15.000000)
#      (psnegative false)
#      (psa4output false)
#      (plotreference true)
#      (plotvalue true)
#      (plotinvisibletext false)
#      (padsonsilk false)
#      (subtractmaskfromsilk false)
#      (outputformat 1)
#      (mirror false)
#      (drillshape 0)
#      (scaleselection 1)
#      (outputdirectory "gerbers/"))
#  )

