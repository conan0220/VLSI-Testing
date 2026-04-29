# Design Compiler synthesis script for HW2 GCD.
# Run from the HW2 directory on the NTHU CAD workstation.

set DESIGN_NAME gcd4
set LIB_ROOT /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC

set_app_var search_path [concat $search_path ./rtl ./scripts $LIB_ROOT/SynopsysDC/db]
set_app_var target_library [list slow.db fast.db]
set_app_var link_library [concat "*" $target_library dw_foundation.sldb]
set_app_var synthetic_library [list dw_foundation.sldb]
set_app_var symbol_library [list generic.sdb]

set hdlin_ff_always_sync_set_reset true
set hdlin_translate_off_skip_text true
set edifout_netlist_only true
set verilogout_no_tri true

file mkdir results
file mkdir results/dc
file mkdir results/dc/work
file mkdir results/netlist

define_design_lib WORK -path results/dc/work

analyze -format verilog [list rtl/gcd4.v]
elaborate $DESIGN_NAME
current_design $DESIGN_NAME
set_operating_conditions -min_library fast -min fast -max_library slow -max slow
link

check_design > results/dc/check_design.rpt

# The testbench uses a 10 ns clock. Adjust PERIOD if the course requires a
# different synthesis constraint.
set PERIOD 10.0
create_clock -name clk -period $PERIOD [get_ports clk]
set_dont_touch_network [get_clocks clk]
set_fix_hold clk
set_input_delay  1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]
set_drive 1 [all_inputs]
set_load [load_of slow/CLKBUFX20/A] [all_outputs]

uniquify
set_fix_multiple_port_nets -all -buffer_constants
set_max_fanout 20.0 $DESIGN_NAME
set_max_area 0
compile -map_effort medium

remove_unconnected_ports [get_cells -hierarchical *]
remove_unconnected_ports [get_cells -hierarchical *] -blast_buses
check_design > results/dc/check_design_after_compile.rpt

set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\*cell\*" "cell"}}
define_name_rules name_rule -map {{"*-return" "myreturn"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule
set verilogout_show_unconnected_pins true

report_area  -hierarchy > results/dc/area.rpt
report_timing -path full -delay max -max_paths 10 > results/dc/timing.rpt
report_power > results/dc/power.rpt
report_qor   > results/dc/qor.rpt
report_cell  > results/dc/cell.rpt
report_reference -hierarchy > results/dc/reference.rpt

write -format verilog -hierarchy -output results/netlist/gcd4_syn.v
write_sdc results/dc/gcd4_syn.sdc
write_sdf -version 2.1 -context verilog -load_delay cell results/dc/gcd4_syn.sdf

puts "Synthesis complete. Fill report/report.md with area, frequency, and power from results/dc/*.rpt."
