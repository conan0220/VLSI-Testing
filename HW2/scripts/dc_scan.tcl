# Design Compiler scan insertion script for HW2 GCD.
# Run from the HW2 directory after scripts/dc_synth.tcl has produced
# results/netlist/gcd4_syn.v.

set DESIGN_NAME gcd4

# TODO(workstation): update these paths to the course standard-cell library.
set_app_var search_path [concat $search_path ./rtl ./scripts ./results/netlist]
set_app_var target_library [list "YOUR_STANDARD_CELL_LIBRARY.db"]
set_app_var link_library   [concat "*" $target_library]
set_app_var synthetic_library [list dw_foundation.sldb]

file mkdir results
file mkdir results/scan
file mkdir results/netlist

read_verilog results/netlist/gcd4_syn.v
current_design $DESIGN_NAME
link

set PERIOD 10.0
create_clock -name clk -period $PERIOD [get_ports clk]
set_input_delay  1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]

set_scan_configuration -style multiplexed_flip_flop
create_port scan_enable -direction in
create_port scan_in -direction in
create_port scan_out -direction out
set_dft_signal -view existing_dft -type ScanClock -port clk -timing {45 55}
set_dft_signal -view existing_dft -type Reset -port rst_n -active_state 0
set_dft_signal -view spec -type ScanEnable -port scan_enable -active_state 1
set_dft_signal -view spec -type ScanDataIn -port scan_in
set_dft_signal -view spec -type ScanDataOut -port scan_out
set_scan_path chain1 -view spec -scan_data_in scan_in -scan_data_out scan_out

create_test_protocol
dft_drc > results/scan/dft_drc_before.rpt
preview_dft > results/scan/preview_dft.rpt
insert_dft
dft_drc > results/scan/dft_drc_after.rpt

compile_ultra -incremental

report_area  -hierarchy > results/scan/area_scan.rpt
report_timing -delay_type max -max_paths 10 > results/scan/timing_scan.rpt
report_qor   > results/scan/qor_scan.rpt
report_scan_path -view existing_dft > results/scan/scan_path.rpt

write -format verilog -hierarchy -output results/netlist/gcd4_scan.v
write_sdc results/scan/gcd4_scan.sdc
write_test_protocol -output results/scan/gcd4_scan.spf

puts "Scan insertion complete. Fill report/report.md with scan area and timing results."
