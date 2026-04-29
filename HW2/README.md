# EE-6250 VLSI Testing HW2

This directory contains the source package for a 4-bit GCD circuit homework.

## Files

- `rtl/gcd4.v`: synthesizable sequential Verilog RTL.
- `tb/gcd4_tb.v`: self-checking RTL testbench with VCD dump.
- `scripts/dc_synth.tcl`: Design Compiler synthesis script.
- `scripts/dc_scan.tcl`: Design Compiler scan insertion script.
- `scripts/tmax_atpg.tcl`: TetraMAX ATPG script template.
- `report/report.md`: report draft with cover page and result placeholders.

## Local Simulation

The default simulation target follows the course training package and uses VCS.

```sh
cd HW2
make sim
```

The simulation writes `results/gcd4_tb.vcd`. If VCS is not available but
Icarus Verilog is installed, use `make sim-iverilog`.

## Workstation Flow

The scripts use the TSMC90 paths from `2026_Spring_Training_Package`:

- DC libraries: `/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SynopsysDC/db/slow.db` and `fast.db`
- Standard-cell Verilog: `/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v`

Run:

```sh
cd HW2
make sim
make synth
make gate-sim
make scan
make atpg
make metrics
```

The ATPG target uses `tmax64` by default. To override it, run for example
`make atpg ATPG_TOOL=/path/to/tool`.

Copy the reported gate count, timing, power, and fault coverage values into
`report/report.md`, then export the report and required appendices to a single
PDF for submission.
