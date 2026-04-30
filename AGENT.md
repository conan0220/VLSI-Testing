# Agent Handoff Notes

## Repository State

- Working directory: `/mnt/d/repos/VLSI-Testing`
- Current branch: `master`
- Latest pushed commit at the time of this note: `a217f0f Record HW2 results and handoff notes`
- Existing unrelated local changes must not be reverted or staged:
  - `HW1/b.cpp`
  - `HW1/c.cpp`
  - `HW1/d.cpp`
  - `HW1/e.cpp`
  - `.codex`
- Do not commit or distribute course/process reference folders unless the user explicitly asks and confirms it is allowed:
  - `HW2/2026_Spring_Training_Package/`
  - `HW2/2026_DFT_ATPG/`

## HW2 Current Status

The HW2 source flow has been implemented and pushed. The user later copied workstation output into:

```text
HW2/results/
```

`HW2/results/` is currently untracked and contains EDA outputs from the previous run, including:

- `results/gcd4_tb.vcd` from the older single-testbench flow
- `results/netlist/gcd4_syn.v`
- `results/netlist/gcd4_scan.v`
- `results/dc/*.rpt`
- `results/scan/*.rpt`
- `results/scan/gcd4_scan.stil`
- `results/atpg/gcd4_fault.rpt`
- `results/atpg/gcd4_patterns.stil`

The following files have local modifications after reading the results and later testbench changes:

- `HW2/report/report.md`
- `HW2/scripts/extract_metrics.py`
- `HW2/Makefile`
- `HW2/tb/gcd4_rtl_tb.v`
- `HW2/tb/gcd4_gate_tb.v`
- deleted `HW2/tb/gcd4_tb.v`

These changes are not committed yet.
Because the testbench was split after the workstation run, `make sim` and `make gate-sim` should be rerun on the workstation before final waveform screenshots. The new waveform names are `results/gcd4_rtl.vcd` and `results/gcd4_syn.vcd`.

## Extracted HW2 Results

Non-scan synthesis:

- Gate count: `191`
- Number of cells: `97`
- Total cell area: `536.961609`
- Gate count formula from `2026_DFT_ATPG.pptx`: `ceil(Total cell area / NAND2 gate area)`, where NAND2 gate area is `2.8224 um^2`
- Worst slack at 10 ns clock: `8.42 ns`
- Estimated critical period: `1.58 ns`
- Maximum operating speed: `632.91 MHz`
- Total power: `0.019093 mW`

Scan insertion:

- Gate count: `213`
- Number of cells: `97`
- Total cell area: `600.465604`
- Worst slack at 10 ns clock: `8.32 ns`
- Estimated critical period: `1.68 ns`
- Maximum operating speed: `595.24 MHz`
- Area overhead: `11.52%`
- Performance penalty: `5.95%`
- Scan chain count: `1`
- Scan chain length: `15`
- DFT DRC violations: `0`

ATPG:

- Fault model: stuck-at
- Total faults: `820`
- Detected faults: `820`
- Not detected faults: `0`
- Test coverage: `100.00%`
- Pattern file: `results/atpg/gcd4_patterns.stil`

## Important Flow Notes

Workstation setup commands used for HW2:

```sh
source /usr/cadtool/user_setup/08-synthesis.csh
source /usr/cadtool/user_setup/08-vcs.csh
source /usr/cadtool/user_setup/08-tmax.csh
source /usr/cad/synopsys/CIC/icc.csh
```

Main flow:

```sh
cd HW2
make sim
make synth
make gate-sim
make scan
make atpg
make metrics
```

RTL simulation now uses `tb/gcd4_rtl_tb.v`, adapted from `2026_Spring_Training_Package/1.RTL_simulation/testbench.v` with 4-bit inputs. Gate-level simulation now uses `tb/gcd4_gate_tb.v`, adapted from `2026_Spring_Training_Package/2.Gate_level_simulation/testbench.v` with 4-bit inputs and SDF annotation.

`make scan` uses `dc_shell-t`. `make atpg` uses `tmax64` and pipes:

```text
source scripts/tmax_atpg.tcl
exit
```

into the TetraMAX shell.

## Next Steps

1. If asked to finalize the report, use `HW2/report/report.md` as the main content.
2. Rerun `make sim` and `make gate-sim`, then add waveform screenshots from `HW2/results/gcd4_rtl.vcd` and, if needed, `HW2/results/gcd4_syn.vcd`.
3. Include appendices in the final PDF:
   - `HW2/rtl/gcd4.v`
   - `HW2/tb/gcd4_rtl_tb.v`
   - `HW2/tb/gcd4_gate_tb.v`
   - `HW2/results/netlist/gcd4_syn.v`
   - `HW2/results/netlist/gcd4_scan.v`
4. If asked to commit, stage only intentional files. Likely candidates:
   - `AGENT.md`
   - `HW2/Makefile`
   - `HW2/report/report.md`
   - `HW2/scripts/extract_metrics.py`
   - `HW2/tb/gcd4_rtl_tb.v`
   - `HW2/tb/gcd4_gate_tb.v`
   - deletion of `HW2/tb/gcd4_tb.v`
5. Do not stage `HW2/results/` unless the user explicitly asks for generated EDA outputs to be committed.
