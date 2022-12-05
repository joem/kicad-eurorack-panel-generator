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
    # A big realistic example, just to be sure.
    s_expression2 = '(kicad_pcb (version 20171130) (host pcbnew "(5.1.2-1)-1") (general (thickness 1.6) (drawings 4) (tracks 0) (zones 0) (modules 0) (nets 1)) (page A4) (layers (0 F.Cu signal) (31 B.Cu signal) (32 B.Adhes user) (33 F.Adhes user) (34 B.Paste user) (35 F.Paste user) (36 B.SilkS user) (37 F.SilkS user) (38 B.Mask user) (39 F.Mask user) (40 Dwgs.User user) (41 Cmts.User user) (42 Eco1.User user) (43 Eco2.User user) (44 Edge.Cuts user) (45 Margin user) (46 B.CrtYd user) (47 F.CrtYd user) (48 B.Fab user) (49 F.Fab user)) (setup (last_trace_width 0.25) (trace_clearance 0.2) (zone_clearance 0.508) (zone_45_only no) (trace_min 0.2) (via_size 0.8) (via_drill 0.4) (via_min_size 0.4) (via_min_drill 0.3) (uvia_size 0.3) (uvia_drill 0.1) (uvias_allowed no) (uvia_min_size 0.2) (uvia_min_drill 0.1) (edge_width 0.05) (segment_width 0.2) (pcb_text_width 0.3) (pcb_text_size 1.5 1.5) (mod_edge_width 0.12) (mod_text_size 1 1) (mod_text_width 0.15) (pad_size 1.524 1.524) (pad_drill 0.762) (pad_to_mask_clearance 0.051) (solder_mask_min_width 0.25) (aux_axis_origin 0 0) (visible_elements FFFFFF7F) (pcbplotparams (layerselection 0x010fc_ffffffff) (usegerberextensions false) (usegerberattributes false) (usegerberadvancedattributes false) (creategerberjobfile false) (excludeedgelayer true) (linewidth 0.100000) (plotframeref false) (viasonmask false) (mode 1) (useauxorigin false) (hpglpennumber 1) (hpglpenspeed 20) (hpglpendiameter 15.000000) (psnegative false) (psa4output false) (plotreference true) (plotvalue true) (plotinvisibletext false) (padsonsilk false) (subtractmaskfromsilk false) (outputformat 1) (mirror false) (drillshape 1) (scaleselection 1) (outputdirectory ""))) (net 0 "") (net_class Default "This is the default net class." (clearance 0.2) (trace_width 0.25) (via_dia 0.8) (via_drill 0.4) (uvia_dia 0.3) (uvia_drill 0.1)) (gr_line (start 13 28) (end 13 13) (layer Edge.Cuts) (width 0.05) (tstamp 5FBB1190)) (gr_line (start 23 28) (end 13 28) (layer Edge.Cuts) (width 0.05)) (gr_line (start 23 13) (end 23 28) (layer Edge.Cuts) (width 0.05)) (gr_line (start 13 13) (end 23 13) (layer Edge.Cuts) (width 0.05)))'
    expected_array2 = [[:kicad_pcb, [:version, 20171130], [:host, :pcbnew, "(5.1.2-1)-1"], [:general, [:thickness, :"1.6"], [:drawings, 4], [:tracks, 0], [:zones, 0], [:modules, 0], [:nets, 1]], [:page, :A4], [:layers, [0, :"F.Cu", :signal], [31, :"B.Cu", :signal], [32, :"B.Adhes", :user], [33, :"F.Adhes", :user], [34, :"B.Paste", :user], [35, :"F.Paste", :user], [36, :"B.SilkS", :user], [37, :"F.SilkS", :user], [38, :"B.Mask", :user], [39, :"F.Mask", :user], [40, :"Dwgs.User", :user], [41, :"Cmts.User", :user], [42, :"Eco1.User", :user], [43, :"Eco2.User", :user], [44, :"Edge.Cuts", :user], [45, :Margin, :user], [46, :"B.CrtYd", :user], [47, :"F.CrtYd", :user], [48, :"B.Fab", :user], [49, :"F.Fab", :user]], [:setup, [:last_trace_width, :"0.25"], [:trace_clearance, :"0.2"], [:zone_clearance, :"0.508"], [:zone_45_only, :no], [:trace_min, :"0.2"], [:via_size, :"0.8"], [:via_drill, :"0.4"], [:via_min_size, :"0.4"], [:via_min_drill, :"0.3"], [:uvia_size, :"0.3"], [:uvia_drill, :"0.1"], [:uvias_allowed, :no], [:uvia_min_size, :"0.2"], [:uvia_min_drill, :"0.1"], [:edge_width, :"0.05"], [:segment_width, :"0.2"], [:pcb_text_width, :"0.3"], [:pcb_text_size, :"1.5", :"1.5"], [:mod_edge_width, :"0.12"], [:mod_text_size, 1, 1], [:mod_text_width, :"0.15"], [:pad_size, :"1.524", :"1.524"], [:pad_drill, :"0.762"], [:pad_to_mask_clearance, :"0.051"], [:solder_mask_min_width, :"0.25"], [:aux_axis_origin, 0, 0], [:visible_elements, :FFFFFF7F], [:pcbplotparams, [:layerselection, :"0x010fc_ffffffff"], [:usegerberextensions, :false], [:usegerberattributes, :false], [:usegerberadvancedattributes, :false], [:creategerberjobfile, :false], [:excludeedgelayer, :true], [:linewidth, :"0.100000"], [:plotframeref, :false], [:viasonmask, :false], [:mode, 1], [:useauxorigin, :false], [:hpglpennumber, 1], [:hpglpenspeed, 20], [:hpglpendiameter, :"15.000000"], [:psnegative, :false], [:psa4output, :false], [:plotreference, :true], [:plotvalue, :true], [:plotinvisibletext, :false], [:padsonsilk, :false], [:subtractmaskfromsilk, :false], [:outputformat, 1], [:mirror, :false], [:drillshape, 1], [:scaleselection, 1], [:outputdirectory, ""]]], [:net, 0, ""], [:net_class, :Default, "This is the default net class.", [:clearance, :"0.2"], [:trace_width, :"0.25"], [:via_dia, :"0.8"], [:via_drill, :"0.4"], [:uvia_dia, :"0.3"], [:uvia_drill, :"0.1"]], [:gr_line, [:start, 13, 28], [:end, 13, 13], [:layer, :"Edge.Cuts"], [:width, :"0.05"], [:tstamp, :"5FBB1190"]], [:gr_line, [:start, 23, 28], [:end, 13, 28], [:layer, :"Edge.Cuts"], [:width, :"0.05"]], [:gr_line, [:start, 23, 13], [:end, 23, 28], [:layer, :"Edge.Cuts"], [:width, :"0.05"]], [:gr_line, [:start, 13, 13], [:end, 23, 13], [:layer, :"Edge.Cuts"], [:width, :"0.05"]]]]
    value(SexprParser.parse(s_expression2)).must_equal expected_array2
  end

end

