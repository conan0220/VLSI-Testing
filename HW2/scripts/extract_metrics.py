#!/usr/bin/env python3
"""Best-effort helper for collecting HW2 report values from EDA reports.

This script does not replace checking the Design Compiler or ATPG reports.
It prints the likely lines that contain area, timing, power, and ATPG coverage
so the final values can be copied into report/report.md.
"""

from pathlib import Path


REPORTS = [
    Path("results/dc/area.rpt"),
    Path("results/dc/cell.rpt"),
    Path("results/dc/timing.rpt"),
    Path("results/dc/power.rpt"),
    Path("results/scan/area_scan.rpt"),
    Path("results/scan/timing_scan.rpt"),
    Path("results/scan/scan_path.rpt"),
    Path("results/atpg/summary.rpt"),
    Path("results/atpg/fault_summary.rpt"),
]

KEYWORDS = (
    "total cell area",
    "number of cells",
    "data arrival time",
    "slack",
    "total dynamic power",
    "cell leakage power",
    "fault coverage",
    "test coverage",
    "patterns",
    "scan chain",
)


def main() -> None:
    for report in REPORTS:
        print(f"\n== {report} ==")
        if not report.exists():
            print("missing")
            continue

        matches = []
        for line in report.read_text(errors="ignore").splitlines():
            lowered = line.lower()
            if any(keyword in lowered for keyword in KEYWORDS):
                matches.append(line.rstrip())

        if matches:
            for line in matches[:40]:
                print(line)
        else:
            print("no keyword matches; inspect this report manually")


if __name__ == "__main__":
    main()
