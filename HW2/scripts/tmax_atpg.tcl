# TetraMAX ATPG script template for HW2 GCD.
# Run from the HW2 directory after scan insertion creates:
#   results/netlist/gcd4_scan.v
#   results/scan/gcd4_scan.spf

set BUILD -replace
file mkdir results
file mkdir results/atpg
set_messages -log results/atpg/tmax.log -replace

set TOP gcd4
set CELL_VERILOG /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v

# If the workstation uses Synopsys TestMAX instead of TetraMAX, keep this file
# as the command reference and run it with the equivalent TestMAX shell command.
read_netlist $CELL_VERILOG -library
read_netlist results/netlist/gcd4_scan.v
run_build_model $TOP
run_drc results/scan/gcd4_scan.spf

set_faults -model stuck
add_faults -all
run_atpg -auto_compression

report_summaries > results/atpg/summary.rpt
report_faults -summary > results/atpg/fault_summary.rpt
write_patterns results/atpg/gcd4_patterns.stil -format stil -replace

puts "ATPG complete. Fill report/report.md with fault coverage from results/atpg/*.rpt."
