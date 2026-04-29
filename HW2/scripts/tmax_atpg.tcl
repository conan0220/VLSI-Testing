# TetraMAX ATPG script for HW2 GCD.
# Run from the HW2 directory after scan insertion creates:
#   results/netlist/gcd4_scan.v
#   results/scan/gcd4_scan.stil

set BUILD -replace
file mkdir results
file mkdir results/atpg

set TOP gcd4
set CELL_VERILOG /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v

read_netlist results/netlist/gcd4_scan.v
read_netlist $CELL_VERILOG -library
report_modules -summary
report_modules -error
report_modules -undefined

run_build_model $TOP
set_drc -allow_unstable_set_resets
run_drc results/scan/gcd4_scan.stil

add_faults -all
set_atpg -merge high -abort_limit 250 -coverage 100 -decision random -fill x
run_atpg

write_faults results/atpg/gcd4_fault.rpt -replace -summary
write_patterns results/atpg/gcd4_patterns.stil -format stil -replace

puts "ATPG complete. Fill report/report.md with fault coverage from results/atpg/gcd4_fault.rpt."
