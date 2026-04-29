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

```sh
cd HW2
make sim
```

The simulation writes `results/gcd4_tb.vcd`.

## Workstation Flow

Update the library placeholders in the scripts, then run:

```sh
cd HW2
make synth
make scan
make atpg
make metrics
```

Copy the reported gate count, timing, power, and fault coverage values into
`report/report.md`, then export the report and required appendices to a single
PDF for submission.
