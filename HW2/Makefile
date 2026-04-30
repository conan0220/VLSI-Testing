RTL := rtl/gcd4.v
RTL_TB := tb/gcd4_rtl_tb.v
GATE_TB := tb/gcd4_gate_tb.v
CELL_VERILOG := /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v
VCS_FLAGS := -full64 -debug_access+all +v2k +neg_tchk
DC_SHELL ?= dc_shell
DFT_SHELL ?= dc_shell-t
ATPG_TOOL ?= tmax64

.PHONY: sim sim-iverilog gate-sim synth scan atpg metrics clean

sim:
	mkdir -p results
	vcs $(RTL_TB) $(RTL) $(VCS_FLAGS) -o results/gcd4_rtl_tb.simv
	./results/gcd4_rtl_tb.simv

sim-iverilog:
	mkdir -p results
	iverilog -g2012 -o results/gcd4_rtl_tb.out $(RTL) $(RTL_TB)
	vvp results/gcd4_rtl_tb.out

gate-sim:
	mkdir -p results
	vcs $(GATE_TB) results/netlist/gcd4_syn.v -v $(CELL_VERILOG) $(VCS_FLAGS) -o results/gcd4_gate_tb.simv
	./results/gcd4_gate_tb.simv

synth:
	$(DC_SHELL) -f scripts/dc_synth.tcl

scan:
	$(DFT_SHELL) -f scripts/dc_scan.tcl

atpg:
	mkdir -p results/atpg
	@test -n "$$SYNOPSYS" || { \
		echo "SYNOPSYS is not set. Source the TetraMAX setup first:"; \
		echo "  source /usr/cadtool/user_setup/08-tmax.csh"; \
		echo "  source /usr/cad/synopsys/CIC/icc.csh"; \
		exit 1; \
	}
	printf "source scripts/tmax_atpg.tcl\nexit\n" | $(ATPG_TOOL)

metrics:
	python3 scripts/extract_metrics.py

clean:
	rm -rf results/*.out results/*.simv results/*.simv.daidir results/*.vcd results/*.fsdb csrc ucli.key \
	       results/dc results/scan results/atpg results/netlist
