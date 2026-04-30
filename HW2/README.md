# EE-6250 VLSI Testing HW2

This directory contains the source package for a 4-bit GCD circuit homework.

## Files

- `rtl/gcd4.v`: synthesizable sequential Verilog RTL.
- `tb/gcd4_rtl_tb.v`: RTL testbench adapted from `1.RTL_simulation/testbench.v` with 4-bit inputs.
- `tb/gcd4_gate_tb.v`: gate-level testbench adapted from `2.Gate_level_simulation/testbench.v` with 4-bit inputs and SDF annotation.
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

The simulation writes `results/gcd4_rtl.vcd`. If VCS is not available but
Icarus Verilog is installed, use `make sim-iverilog`.

## Workstation Flow

The scripts use the TSMC90 paths from `2026_Spring_Training_Package`:

- DC libraries: `/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SynopsysDC/db/slow.db` and `fast.db`
- Standard-cell Verilog: `/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v`

The DFT/ATPG flow follows `2026_DFT_ATPG`:

- DFT Compiler: `dc_shell-t`
- TetraMAX ATPG: `tmax64`, with `source scripts/tmax_atpg.tcl` inside the shell
- Scan test protocol: `results/scan/gcd4_scan.stil`
- Fault report: `results/atpg/gcd4_fault.rpt`

Source the course tool setup files before running the flow:

```sh
source /usr/cadtool/user_setup/08-synthesis.csh
source /usr/cadtool/user_setup/08-vcs.csh
source /usr/cadtool/user_setup/08-tmax.csh
source /usr/cad/synopsys/CIC/icc.csh
```

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

`make scan` uses `dc_shell-t` by default. `make atpg` uses `tmax64` by default.
To override either executable, run for example
`make scan DFT_SHELL=/path/to/dc_shell-t` or
`make atpg ATPG_TOOL=/path/to/tmax64`.

Copy the reported gate count, timing, power, and fault coverage values into
`report/report.md`, then export the report and required appendices to a single
PDF for submission.
