RTL := rtl/gcd4.v
TB  := tb/gcd4_tb.v

.PHONY: sim synth scan atpg metrics clean

sim:
	mkdir -p results
	iverilog -g2012 -o results/gcd4_tb.out $(RTL) $(TB)
	vvp results/gcd4_tb.out

synth:
	dc_shell -f scripts/dc_synth.tcl

scan:
	dc_shell -f scripts/dc_scan.tcl

atpg:
	mkdir -p results/atpg
	tmax -shell scripts/tmax_atpg.tcl

metrics:
	python3 scripts/extract_metrics.py

clean:
	rm -rf results/*.out results/*.vcd results/dc results/scan results/atpg results/netlist
