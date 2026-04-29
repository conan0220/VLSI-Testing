RTL := rtl/gcd4.v
TB  := tb/gcd4_tb.v
CELL_VERILOG := /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v
VCS_FLAGS := -full64 -debug_access+all +v2k +neg_tchk
ATPG_TOOL ?= tmax64

.PHONY: sim sim-iverilog gate-sim synth scan atpg metrics clean

sim:
	mkdir -p results
	vcs $(TB) $(RTL) $(VCS_FLAGS) -o results/gcd4_tb.simv
	./results/gcd4_tb.simv

sim-iverilog:
	mkdir -p results
	iverilog -g2012 -o results/gcd4_tb.out $(RTL) $(TB)
	vvp results/gcd4_tb.out

gate-sim:
	mkdir -p results
	vcs $(TB) results/netlist/gcd4_syn.v -v $(CELL_VERILOG) $(VCS_FLAGS) -o results/gcd4_gate_tb.simv
	./results/gcd4_gate_tb.simv

synth:
	dc_shell -f scripts/dc_synth.tcl

scan:
	dc_shell -f scripts/dc_scan.tcl

atpg:
	mkdir -p results/atpg
	$(ATPG_TOOL) -shell scripts/tmax_atpg.tcl

metrics:
	python3 scripts/extract_metrics.py

clean:
	rm -rf results/*.out results/*.simv results/*.simv.daidir results/*.vcd csrc ucli.key \
	       results/dc results/scan results/atpg results/netlist
