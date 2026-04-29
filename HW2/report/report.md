# EE-6250 超大型積體電路測試 Homework #2

## 封面

課程：EE-6250 超大型積體電路測試 VLSI Testing
作業：Homework #2
系所：國立清華大學 半導體研究學院設計部
姓名：黃守翊
英文姓名：Shou-Yi Huang
學號：114501522

## 1. GCD 電路設計

### 1(a). RTL 程式碼

本電路用來計算兩個 4-bit 正整數的最大公因數。RTL 採用循序式 Euclidean algorithm，透過 repeated subtraction 完成 GCD 運算。外部介面包含 `clk`、低有效 reset `rst_n`、一個週期的 `start` 啟動訊號、兩個 4-bit 輸入運算元、4-bit `gcd` 輸出，以及表示運算完成的 `done` 訊號。

設計使用三個狀態：

| 狀態 | 功能 |
|---|---|
| `S_IDLE` | 等待 `start`，並載入 `in_a` / `in_b`。 |
| `S_RUN` | 重複將較大值減去較小值，直到兩個暫存器中的值相等。 |
| `S_DONE` | 保持 GCD 結果並拉高 `done`，直到 `start` 解除後回到 idle。 |

設計檔案：

- RTL：`rtl/gcd4.v`
- Testbench：`tb/gcd4_tb.v`

### 1(b). RTL 驗證

RTL testbench 為 self-checking testbench，會自動比對輸出是否符合預期結果，並輸出 waveform 檔案 `results/gcd4_tb.vcd`。測試向量包含超過題目要求的三組輸入。

| 測試 | Input A | Input B | 預期 GCD | 結果 |
|---:|---:|---:|---:|---|
| 1 | 12 | 8 | 4 | TODO：simulation 後確認 |
| 2 | 15 | 10 | 5 | TODO：simulation 後確認 |
| 3 | 7 | 3 | 1 | TODO：simulation 後確認 |
| 4 | 9 | 9 | 9 | TODO：simulation 後確認 |
| 5 | 1 | 15 | 1 | TODO：simulation 後確認 |
| 6 | 14 | 6 | 2 | TODO：simulation 後確認 |

工作站模擬指令：

```sh
cd HW2
make sim
```

`make sim` 使用課程 training package 相同的 VCS flow。若只在本機使用 Icarus Verilog，可改用 `make sim-iverilog`。

預期模擬輸出：

```text
PASS: gcd(12,8) = 4
PASS: gcd(15,10) = 5
PASS: gcd(7,3) = 1
PASS: gcd(9,9) = 9
PASS: gcd(1,15) = 1
PASS: gcd(14,6) = 2
SUMMARY: 6 passed, 0 failed
```

最終 PDF 中需放入 waveform 截圖。請使用 GTKWave、Verdi 或其他 waveform viewer 開啟 `results/gcd4_tb.vcd`，並截取 `clk`、`rst_n`、`start`、`in_a`、`in_b`、`gcd`、`done` 等主要訊號。

### 1(c). Synthesis 結果

Synthesis script：`scripts/dc_synth.tcl`

此 script 已使用 training package 中的 TSMC90 library 設定：

```text
/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SynopsysDC/db/slow.db
/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SynopsysDC/db/fast.db
```

請在 EDA 工作站執行：

```sh
cd HW2
make synth
```

請根據 Design Compiler 產生的 reports 回填下表：

| 項目 | Non-scan 結果 | 來源報告 |
|---|---:|---|
| Gate count | TODO | `results/dc/area.rpt` 或 `results/dc/cell.rpt` |
| Maximum operating speed (MHz) | TODO | `results/dc/timing.rpt` |
| Estimated power dissipation (mW) | TODO | `results/dc/power.rpt` |

Synthesis script 會產生以下 gate-level netlist：

```text
results/netlist/gcd4_syn.v
```

可用下列指令對 synthesized netlist 進行 gate-level simulation：

```sh
cd HW2
make gate-sim
```

此 target 會使用 training package 指定的 standard-cell Verilog model：

```text
/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v
```

## 2. Scan Chain 與 ATPG 測試

### 2(a). Scan Chain Insertion

Scan insertion script：`scripts/dc_scan.tcl`

此 script 與 synthesis 使用相同的 TSMC90 `slow.db` / `fast.db` library 設定。

請在 synthesis 完成後，於 EDA 工作站執行：

```sh
cd HW2
make scan
```

Scan script 會插入 multiplexed flip-flop scan chain，並新增以下 scan ports：

| Port | 方向 | 用途 |
|---|---|---|
| `scan_enable` | Input | 選擇 scan shift mode。 |
| `scan_in` | Input | Scan chain 的 serial input。 |
| `scan_out` | Output | Scan chain 的 serial output。 |

請根據 scan insertion reports 回填下表：

| 項目 | Non-scan | Scan | 公式 / 來源 |
|---|---:|---:|---|
| Gate count | TODO | TODO | `area.rpt`、`area_scan.rpt` |
| Maximum operating speed (MHz) | TODO | TODO | `timing.rpt`、`timing_scan.rpt` |
| Area overhead (%) | TODO | TODO | `(scan_gate_count - nonscan_gate_count) / nonscan_gate_count * 100` |
| Performance penalty (%) | TODO | TODO | `(nonscan_freq - scan_freq) / nonscan_freq * 100` |

Scan insertion script 會產生以下 scan-inserted netlist：

```text
results/netlist/gcd4_scan.v
```

### 2(b). ATPG Fault Coverage

ATPG script template：`scripts/tmax_atpg.tcl`

此 script 已使用 training package 指定的 standard-cell Verilog model：

```text
/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v
```

Training package 中沒有提供 scan/ATPG 範例，因此此處假設工作站可用 Synopsys TetraMAX 指令 `tmax`。若工作站使用的是 TestMAX 或其他 ATPG 執行檔，請用相同 script 內容改以該工具的 shell command 執行。

請在 scan insertion 完成後，於 EDA 工作站執行：

```sh
cd HW2
make atpg
```

請根據 ATPG reports 回填下表：

| 項目 | 結果 | 來源報告 |
|---|---:|---|
| Fault model | Stuck-at | `scripts/tmax_atpg.tcl` |
| Fault coverage (%) | TODO | `results/atpg/summary.rpt` 或 `results/atpg/fault_summary.rpt` |
| Pattern count | TODO | `results/atpg/summary.rpt` |

## High-Level 設計理念

本設計採用 Euclidean algorithm，因為對 4-bit GCD 電路而言，它只需要兩個 operand registers、比較器、減法器與小型 controller，就能完成正整數 GCD 運算。RTL 採用循序式架構，而不是純組合邏輯，是為了讓 synthesis 後的電路具有 flip-flops，使後續 scan chain insertion 與 scan/non-scan 比較具有實際意義。

`start` / `done` protocol 讓 testbench 可以清楚地啟動每一筆測試並等待運算完成，也讓 synthesis constraint 與 timing analysis 有明確的 clocked boundary。整體設計重點是保持 datapath 簡單、controller 容易驗證，並讓後續 Design-for-Test flow 可以自然接上。

## Appendix A. RTL

最終合併 PDF 中請放入 `rtl/gcd4.v` 的內容。

## Appendix B. Testbench

最終合併 PDF 中請放入 `tb/gcd4_tb.v` 的內容。

## Appendix C. Synthesized Netlist

執行 Design Compiler 後，請將 `results/netlist/gcd4_syn.v` 放入最終合併 PDF。

## Appendix D. Scan-Inserted Netlist

執行 scan insertion 後，請將 `results/netlist/gcd4_scan.v` 放入最終合併 PDF。
