# Design Compiler synthesis script for HW2 GCD.
# Run from the HW2 directory after setting the library variables below.

set DESIGN_NAME gcd4

# TODO(workstation): update these paths to the course standard-cell library.
set_app_var search_path [concat $search_path ./rtl ./scripts]
set_app_var target_library [list "YOUR_STANDARD_CELL_LIBRARY.db"]
set_app_var link_library   [concat "*" $target_library]
set_app_var synthetic_library [list dw_foundation.sldb]

file mkdir results
file mkdir results/dc
file mkdir results/dc/work
file mkdir results/netlist

define_design_lib WORK -path results/dc/work

analyze -format verilog [list rtl/gcd4.v]
elaborate $DESIGN_NAME
current_design $DESIGN_NAME
link

check_design > results/dc/check_design.rpt

# The testbench uses a 10 ns clock. Adjust PERIOD if the course requires a
# different synthesis constraint.
set PERIOD 10.0
create_clock -name clk -period $PERIOD [get_ports clk]
set_input_delay  1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]
set_load 0.05 [all_outputs]

set_fix_multiple_port_nets -all -buffer_constants
compile_ultra

report_area  -hierarchy > results/dc/area.rpt
report_timing -delay_type max -max_paths 10 > results/dc/timing.rpt
report_power > results/dc/power.rpt
report_qor   > results/dc/qor.rpt
report_cell  > results/dc/cell.rpt
report_reference -hierarchy > results/dc/reference.rpt

write -format verilog -hierarchy -output results/netlist/gcd4_syn.v
write_sdc results/dc/gcd4_syn.sdc
write_sdf results/dc/gcd4_syn.sdf

puts "Synthesis complete. Fill report/report.md with area, frequency, and power from results/dc/*.rpt."
